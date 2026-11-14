// ignore_for_file: use_build_context_synchronously
import 'dart:async';

import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/premium/presentation/providers/premium_provider.dart';
import 'package:exim_lab/core/services/notification_router.dart';
import 'package:exim_lab/features/payments/presentation/providers/payment_provider.dart';
import 'package:exim_lab/features/payments/presentation/widgets/payment_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Bottom sheet that runs the in-app checkout.
///
/// The WhatsApp CTA is kept as a fallback via [onWhatsApp]; callers decide
/// whether to show this sheet at all (only when `PaymentProvider.enabled`).
///
/// Returns the final [PaymentOutcome], or null if dismissed.
Future<PaymentOutcome?> showCheckoutSheet(
  BuildContext context, {
  required String productType,
  String? productId,
  required String title,
  String? priceLabel,
  VoidCallback? onWhatsApp,
}) {
  return showModalBottomSheet<PaymentOutcome>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => _CheckoutSheet(
      productType: productType,
      productId: productId,
      title: title,
      priceLabel: priceLabel,
      onWhatsApp: onWhatsApp,
    ),
  );
}

class _CheckoutSheet extends StatefulWidget {
  final String productType;
  final String? productId;
  final String title;
  final String? priceLabel;
  final VoidCallback? onWhatsApp;

  const _CheckoutSheet({
    required this.productType,
    required this.productId,
    required this.title,
    required this.priceLabel,
    required this.onWhatsApp,
  });

  @override
  State<_CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<_CheckoutSheet> {
  final _coupon = TextEditingController();
  bool _showCoupon = false;
  bool _busy = false;
  String? _error;
  String? _couponError;

  @override
  void dispose() {
    _coupon.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    if (_busy) return;
    // Capture before awaiting: the sheet may be popped by then.
    final payments = context.read<PaymentProvider>();
    final auth = context.read<AuthProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final perks =
        context.read<PremiumProvider>().config?.pricing?.benefits ?? const <String>[];

    setState(() {
      _busy = true;
      _error = null;
      _couponError = null;
    });

    final attempt = await payments.pay(
      productType: widget.productType,
      productId: widget.productId,
      couponCode: _coupon.text,
    );

    switch (attempt.outcome) {
      case PaymentOutcome.success:
        unawaited(auth.refreshMembershipStatus());
        navigator.pop(attempt.outcome);
        // Celebration instead of a plain toast. Shown only after the backend
        // verified the payment (PaymentOutcome.success).
        final rootContext = NotificationRouter.navigatorKey.currentContext;
        if (rootContext != null) {
          unawaited(
            // App-root context (not this sheet's), so it outlives the sheet.
            showPaymentSuccessDialog(
              rootContext,
              productType: widget.productType,
              validUntil: attempt.result?.accessEndsAt,
              perks: perks,
              amountPaise: attempt.result?.amount,
            ),
          );
        }
        return;
      case PaymentOutcome.pending:
        unawaited(auth.refreshMembershipStatus());
        messenger.showSnackBar(SnackBar(content: Text(attempt.message)));
        navigator.pop(attempt.outcome);
        return;
      case PaymentOutcome.cancelled:
        break; // user backed out; stay on the sheet, no error
      case PaymentOutcome.couponError:
        _couponError = attempt.message;
        _showCoupon = true;
      case PaymentOutcome.disabled:
        _error = 'Online payment is unavailable right now.';
      case PaymentOutcome.unavailable:
      case PaymentOutcome.failed:
        _error = attempt.message;
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 4, 20, 20 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            if (widget.priceLabel != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.priceLabel!,
                style: tt.titleMedium?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (_showCoupon)
              TextField(
                controller: _coupon,
                enabled: !_busy,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: 'Coupon code',
                  errorText: _couponError,
                  border: const OutlineInputBorder(),
                ),
              )
            else
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _busy
                      ? null
                      : () => setState(() => _showCoupon = true),
                  child: const Text('Have a coupon?'),
                ),
              ),
            if (_error != null && _error!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: cs.error)),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _busy ? null : _pay,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _busy
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Pay securely',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
            ),
            if (widget.onWhatsApp != null) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _busy
                    ? null
                    : () {
                        Navigator.of(context).pop();
                        widget.onWhatsApp!();
                      },
                icon: const Icon(Icons.chat_outlined),
                label: const Text('Chat on WhatsApp instead'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
