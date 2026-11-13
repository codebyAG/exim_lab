import 'dart:async';
import 'dart:developer' as developer;

import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/core/services/shared_pref_service.dart';
import 'package:exim_lab/features/payments/data/models/payment_models.dart';
import 'package:exim_lab/features/payments/data/services/payment_service.dart';
import 'package:flutter/widgets.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

enum PaymentOutcome {
  /// Server verified the payment and granted access.
  success,

  /// Money may have been taken but the server hasn't confirmed yet. NOT a
  /// failure — entitlements/status will resolve it (backend recovers < ~2 min).
  pending,
  cancelled,
  failed,

  /// Kill switch off / config missing. Caller should offer WhatsApp.
  disabled,

  /// Product can't be sold online (no price, unpublished, 100% discount).
  unavailable,

  /// Coupon rejected. [PaymentAttempt.message] is safe to show inline.
  couponError,
}

class PaymentAttempt {
  final PaymentOutcome outcome;
  final String message;
  final PaymentResult? result;

  const PaymentAttempt(this.outcome, {this.message = '', this.result});
}

class _SdkResult {
  final PaymentSuccessResponse? success;
  final PaymentFailureResponse? failure;
  const _SdkResult({this.success, this.failure});
}

/// Owns payment config, entitlements and the checkout flow.
///
/// Golden rule: the Razorpay SDK callback is never proof of payment. Content is
/// unlocked only from `/payments/verify` or `/payments/entitlements`.
class PaymentProvider extends ChangeNotifier with WidgetsBindingObserver {
  PaymentProvider({PaymentService? service, PendingPaymentStore? store})
    : _service = service ?? PaymentService(),
      _store = store ?? PendingPaymentStore() {
    WidgetsBinding.instance.addObserver(this);
  }

  static const _genericFailure =
      'Payment could not be completed. Please try again or contact support.';
  static const _pendingMessage =
      'Payment received — confirming with the server. Access will appear shortly.';
  static const _pendingMaxAge = Duration(hours: 24);

  // Server says the order is definitively dead; stop tracking it locally.
  static const _terminalStatuses = {'FAILED', 'CANCELLED', 'EXPIRED'};
  // Never reveal detail on these — just a generic failure.
  static const _doNotUnlockCodes = {
    'SIGNATURE_MISMATCH',
    'AMOUNT_MISMATCH',
    'NOT_YOUR_ORDER',
    // Server has never heard of this order: nothing to wait for.
    'ORDER_NOT_FOUND',
  };

  final PaymentService _service;
  final PendingPaymentStore _store;

  PaymentConfig config = PaymentConfig.disabled;
  Entitlements entitlements = Entitlements.none;
  bool configLoaded = false;

  bool _inFlight = false;
  bool _refreshing = false;

  /// Called when the paid-premium entitlement flips (e.g. a payment that was
  /// recovered after a crash). Wired to AuthProvider so the app unlocks.
  Future<void> Function()? onPremiumChanged;

  bool get isBusy => _inFlight;

  /// In-app checkout is available. When false, show only the WhatsApp CTA.
  bool get enabled => configLoaded && config.enabled;

  bool ownsCourse(String courseId) => entitlements.ownsCourse(courseId);

  // ───────────────────────── lifecycle ─────────────────────────

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(refresh());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ───────────────────────── config + entitlements ─────────────────────────

  Future<void> loadConfig() async {
    config = await _service.fetchConfig();
    configLoaded = true;
    notifyListeners();
  }

  /// Call on app start, on resume and after login: re-reads config, settles any
  /// order left pending by a crash, then re-reads what the user owns.
  Future<void> refresh() async {
    if (_refreshing || _inFlight) return;
    _refreshing = true;
    try {
      await loadConfig();
      final token = await SharedPrefService().getToken();
      if (token == null || token.isEmpty) {
        if (entitlements != Entitlements.none) {
          entitlements = Entitlements.none;
          notifyListeners();
        }
        return;
      }
      await _recoverPending();
      await _loadEntitlements();
    } finally {
      _refreshing = false;
    }
  }

  Future<void> _loadEntitlements() async {
    try {
      final before = entitlements.isPremium;
      entitlements = await _service.fetchEntitlements();
      notifyListeners();
      if (before != entitlements.isPremium) {
        unawaited(onPremiumChanged?.call());
      }
    } catch (e) {
      developer.log('Entitlements fetch failed: $e', name: 'PAYMENTS');
    }
  }

  Future<void> refreshEntitlements() => _loadEntitlements();

  /// Resolve an order that was open when the app died / lost network.
  Future<void> _recoverPending() async {
    final pending = await _store.read();
    if (pending == null) return;

    if (DateTime.now().difference(pending.createdAt) > _pendingMaxAge) {
      await _store.clear();
      return;
    }
    try {
      final r = await _service.status(pending.orderId);
      if (r.isPaid || _terminalStatuses.contains(r.status.toUpperCase())) {
        await _store.clear();
      }
    } on ApiException catch (e) {
      if (e.code == 'ORDER_NOT_FOUND' || e.code == 'NOT_YOUR_ORDER') {
        await _store.clear();
      }
      // Anything else (offline etc.): keep it and retry next time.
    } catch (_) {}
  }

  // ───────────────────────── checkout ─────────────────────────

  /// Create an order, open Razorpay, then have the backend verify.
  /// Never sends a price — only what is being bought.
  Future<PaymentAttempt> pay({
    required String productType,
    String? productId,
    String? couponCode,
  }) async {
    if (!enabled) return const PaymentAttempt(PaymentOutcome.disabled);
    if (_inFlight) {
      return const PaymentAttempt(
        PaymentOutcome.failed,
        message: 'A payment is already in progress.',
      );
    }
    _inFlight = true;
    notifyListeners();
    try {
      final PaymentOrder order;
      try {
        order = await _service.createOrder(
          productType: productType,
          productId: productId,
          couponCode: couponCode,
        );
      } on ApiException catch (e) {
        return _orderError(e);
      }

      await _store.save(
        PendingPayment(
          orderId: order.orderId,
          productType: productType,
          productId: productId ?? '',
          createdAt: DateTime.now(),
        ),
      );

      final sdk = await _openCheckout(order);

      final ok = sdk.success;
      if (ok != null &&
          (ok.paymentId ?? '').isNotEmpty &&
          (ok.signature ?? '').isNotEmpty) {
        return await _verify(order, ok);
      }

      // Cancelled or errored in the SDK.
      final f = sdk.failure;
      final cancelled = f?.code == Razorpay.PAYMENT_CANCELLED;
      unawaited(
        _service.reportFailed(
          orderId: order.orderId,
          code: cancelled ? 'PAYMENT_CANCELLED' : 'PAYMENT_FAILED',
          description: f?.message ?? '',
        ),
      );
      await _store.clear();
      return cancelled
          ? const PaymentAttempt(PaymentOutcome.cancelled)
          : const PaymentAttempt(
              PaymentOutcome.failed,
              message: _genericFailure,
            );
    } finally {
      _inFlight = false;
      notifyListeners();
    }
  }

  PaymentAttempt _orderError(ApiException e) {
    switch (e.code) {
      case 'PAYMENTS_DISABLED':
        return const PaymentAttempt(PaymentOutcome.disabled);
      case 'NO_TOKEN':
        return const PaymentAttempt(
          PaymentOutcome.failed,
          message: 'Please log in to continue.',
        );
      case 'PRODUCT_UNAVAILABLE':
        return const PaymentAttempt(
          PaymentOutcome.unavailable,
          message: 'This is no longer available.',
        );
      case 'PRICE_NOT_SET':
      case 'ZERO_AMOUNT':
        return const PaymentAttempt(
          PaymentOutcome.unavailable,
          message: 'Online payment isn\'t available for this yet.',
        );
      case 'COUPON_INVALID':
      case 'COUPON_EXPIRED':
      case 'COUPON_EXHAUSTED':
      case 'COUPON_NOT_YOURS':
      case 'COUPON_WRONG_PRODUCT':
        return PaymentAttempt(PaymentOutcome.couponError, message: e.message);
      case 'ORDER_CREATE_FAILED':
        return const PaymentAttempt(
          PaymentOutcome.failed,
          message: 'Could not start the payment. Please try again.',
        );
      default:
        return PaymentAttempt(
          PaymentOutcome.failed,
          message: e.message.isEmpty ? _genericFailure : e.message,
        );
    }
  }

  Future<PaymentAttempt> _verify(
    PaymentOrder order,
    PaymentSuccessResponse sdk,
  ) async {
    try {
      final r = await _service.verify(
        orderId: sdk.orderId ?? order.orderId,
        paymentId: sdk.paymentId!,
        signature: sdk.signature!,
      );
      if (r.isPaid) return await _settled(r);
      return await _confirmViaStatus(order);
    } on ApiException catch (e) {
      if (_doNotUnlockCodes.contains(e.code)) {
        await _store.clear();
        return const PaymentAttempt(
          PaymentOutcome.failed,
          message: _genericFailure,
        );
      }
      // Network drop / 5xx: money may have moved. Ask the server directly
      // before ever saying "failed"; otherwise stay pending.
      return await _confirmViaStatus(order);
    } catch (_) {
      return await _confirmViaStatus(order);
    }
  }

  Future<PaymentAttempt> _confirmViaStatus(PaymentOrder order) async {
    try {
      final r = await _service.status(order.orderId);
      if (r.isPaid) return await _settled(r);
    } catch (_) {}
    // Pending order stays stored → recovered on resume / next launch.
    return const PaymentAttempt(
      PaymentOutcome.pending,
      message: _pendingMessage,
    );
  }

  Future<PaymentAttempt> _settled(PaymentResult r) async {
    await _store.clear();
    await _loadEntitlements();
    return PaymentAttempt(PaymentOutcome.success, result: r);
  }

  Future<_SdkResult> _openCheckout(PaymentOrder order) {
    final completer = Completer<_SdkResult>();
    final razorpay = Razorpay();

    void finish(_SdkResult r) {
      if (!completer.isCompleted) completer.complete(r);
    }

    razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      (PaymentSuccessResponse r) => finish(_SdkResult(success: r)),
    );
    razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      (PaymentFailureResponse r) => finish(_SdkResult(failure: r)),
    );
    // External wallets hand off to another app; the result still arrives via
    // success/error, so nothing to do here.
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse _) {});

    final key = order.keyId.isNotEmpty ? order.keyId : config.keyId;
    try {
      razorpay.open({
        'key': key,
        'order_id': order.orderId,
        'amount': order.amount, // paise, passed through unchanged
        'currency': order.currency,
        'name': 'Start Import Export',
        'description': order.productTitle,
        'prefill': {
          if (order.prefillContact.isNotEmpty) 'contact': order.prefillContact,
          if (order.prefillEmail.isNotEmpty) 'email': order.prefillEmail,
          if (order.prefillName.isNotEmpty) 'name': order.prefillName,
        },
        'theme': {'color': '#020C28'},
      });
    } catch (e) {
      finish(
        _SdkResult(
          failure: PaymentFailureResponse(
            Razorpay.UNKNOWN_ERROR,
            e.toString(),
            null,
          ),
        ),
      );
    }

    return completer.future.whenComplete(razorpay.clear);
  }
}

/// ₹ formatting for paise amounts (display only).
String formatPaise(int paise) {
  final rupees = paise / 100;
  return rupees == rupees.roundToDouble()
      ? '₹${rupees.toInt()}'
      : '₹${rupees.toStringAsFixed(2)}';
}
