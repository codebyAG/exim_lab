import 'package:exim_lab/core/functions/whatsapp_utils.dart';
import 'package:exim_lab/features/payments/presentation/providers/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Secondary "Chat on WhatsApp" button shown BELOW an upgrade/pay button.
///
/// Only rendered when in-app payment is enabled: in that case the primary
/// button pays, so WhatsApp needs its own button. When payments are disabled
/// the primary button already opens WhatsApp, so this hides itself to avoid a
/// duplicate.
class WhatsAppFallbackButton extends StatelessWidget {
  final String number;
  final String message;
  final Color foreground;

  const WhatsAppFallbackButton({
    super.key,
    required this.number,
    required this.message,
    this.foreground = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final paymentsOn = context.watch<PaymentProvider>().enabled;
    if (!paymentsOn || number.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => WhatsAppUtils.launch(number: number, message: message),
          icon: const Icon(Icons.chat_rounded, size: 18),
          label: const Text(
            'Chat on WhatsApp',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: foreground,
            side: BorderSide(color: foreground.withValues(alpha: 0.5)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}
