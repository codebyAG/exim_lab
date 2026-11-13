import 'dart:convert';

import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/payments/data/models/payment_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic> _data(dynamic json) {
  final data = json is Map ? json['data'] : null;
  if (data is! Map) throw ApiException(message: 'Malformed server response');
  return Map<String, dynamic>.from(data);
}

class PaymentService {
  /// Public. Never throws — any failure degrades to "payments disabled" so the
  /// app falls back to the WhatsApp CTA instead of a broken sheet.
  Future<PaymentConfig> fetchConfig() async {
    try {
      return await callApi<PaymentConfig>(
        ApiConstants.paymentsConfig,
        logErrorEvent: false,
        parser: (json) => PaymentConfig.fromJson(_data(json)),
      );
    } catch (_) {
      return PaymentConfig.disabled;
    }
  }

  /// The client never sends a price — only what is being bought.
  Future<PaymentOrder> createOrder({
    required String productType,
    String? productId,
    String? couponCode,
  }) {
    return callApi<PaymentOrder>(
      ApiConstants.paymentsOrder,
      methodType: MethodType.post,
      logErrorEvent: false,
      requestData: {
        'productType': productType,
        if (productId != null && productId.isNotEmpty) 'productId': productId,
        if (couponCode != null && couponCode.trim().isNotEmpty)
          'couponCode': couponCode.trim(),
      },
      parser: (json) => PaymentOrder.fromJson(_data(json)),
    );
  }

  /// Sends the SDK payload unchanged. Only the server's answer counts.
  Future<PaymentResult> verify({
    required String orderId,
    required String paymentId,
    required String signature,
  }) {
    return callApi<PaymentResult>(
      ApiConstants.paymentsVerify,
      methodType: MethodType.post,
      logErrorEvent: false,
      requestData: {
        'razorpay_order_id': orderId,
        'razorpay_payment_id': paymentId,
        'razorpay_signature': signature,
      },
      parser: (json) => PaymentResult.fromJson(_data(json)),
    );
  }

  Future<PaymentResult> status(String orderId) {
    return callApi<PaymentResult>(
      ApiConstants.paymentsStatus(orderId),
      logErrorEvent: false,
      parser: (json) => PaymentResult.fromJson(_data(json)),
    );
  }

  /// Fire-and-forget lead signal. Response is ignored, errors swallowed.
  Future<void> reportFailed({
    required String orderId,
    required String code,
    required String description,
  }) async {
    try {
      await callApi<void>(
        ApiConstants.paymentsFailed,
        methodType: MethodType.post,
        logErrorEvent: false,
        requestData: {
          'orderId': orderId,
          'code': code,
          'description': description,
        },
        parser: (_) {},
      );
    } catch (_) {}
  }

  Future<Entitlements> fetchEntitlements() {
    return callApi<Entitlements>(
      ApiConstants.paymentsEntitlements,
      logErrorEvent: false,
      parser: (json) => Entitlements.fromJson(_data(json)),
    );
  }
}

/// Persists the in-flight order so a crash between "paid" and "verified" can
/// be resolved on next launch via `/payments/status/:orderId`.
class PendingPaymentStore {
  static const _key = 'pending_payment';

  Future<void> save(PendingPayment p) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(p.toJson()));
    } catch (_) {}
  }

  Future<PendingPayment?> read() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return null;
      final p = PendingPayment.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw)),
      );
      return p.orderId.isEmpty ? null : p;
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (_) {}
  }
}
