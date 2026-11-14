import 'dart:math' as math;

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Celebration dialog shown after the BACKEND has verified a payment.
///
/// Premium gets the full "you're a member" treatment; other products get a
/// shorter thank-you. Never call this from the raw SDK callback — only after
/// `/payments/verify` (or `/status`) says PAID.
Future<void> showPaymentSuccessDialog(
  BuildContext context, {
  required String productType,
  DateTime? validUntil,
  List<String> perks = const [],
  int? amountPaise,
}) {
  HapticFeedback.mediumImpact();
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black87,
    builder: (_) => _PaymentSuccessDialog(
      productType: productType,
      validUntil: validUntil,
      perks: perks,
      amountPaise: amountPaise,
    ),
  );
}

const _navy = Color(0xFF020C28);
const _navyLight = Color(0xFF0A2066);
const _gold = Color(0xFFFFD000);

class _PaymentSuccessDialog extends StatefulWidget {
  final String productType;
  final DateTime? validUntil;
  final List<String> perks;
  final int? amountPaise;

  const _PaymentSuccessDialog({
    required this.productType,
    required this.validUntil,
    required this.perks,
    required this.amountPaise,
  });

  @override
  State<_PaymentSuccessDialog> createState() => _PaymentSuccessDialogState();
}

class _PaymentSuccessDialogState extends State<_PaymentSuccessDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _confetti = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  )..forward();

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  bool get _isPremium => widget.productType == 'premium';

  static const _fallbackPerks = [
    'All courses & lessons unlocked',
    'AI Trade Expert & business tools',
    'Premium resources & live sessions',
  ];

  // What the customer actually bought, straight from the server's Premium
  // page config; a generic list only if that isn't available.
  List<String> get _perks {
    final fromServer = widget.perks
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .take(5)
        .toList();
    return fromServer.isEmpty ? _fallbackPerks : fromServer;
  }

  String? get _receipt {
    final p = widget.amountPaise;
    if (p == null || p <= 0) return null;
    final rupees = p / 100;
    final amt = rupees == rupees.roundToDouble()
        ? NumberFormat.decimalPattern('en_IN').format(rupees.toInt())
        : rupees.toStringAsFixed(2);
    return 'Paid ₹$amt';
  }

  @override
  Widget build(BuildContext context) {
    final until = widget.validUntil == null
        ? null
        : DateFormat('d MMM yyyy').format(widget.validUntil!.toLocal());

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_navyLight, _navy],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Crown badge
                  ElasticIn(
                    duration: const Duration(milliseconds: 1100),
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _gold.withValues(alpha: 0.14),
                        border: Border.all(color: _gold, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: _gold.withValues(alpha: 0.45),
                            blurRadius: 32,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _isPremium ? '👑' : '✅',
                          style: const TextStyle(fontSize: 46),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  FadeInUp(
                    delay: const Duration(milliseconds: 250),
                    child: Text(
                      _isPremium ? 'Congratulations! 🎉' : 'Payment Successful',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeInUp(
                    delay: const Duration(milliseconds: 380),
                    child: Text(
                      _isPremium
                          ? 'You are now a Premium member'
                          : 'Thank you! Your payment was received.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _gold,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (_isPremium) ...[
                    const SizedBox(height: 18),
                    FadeInUp(
                      delay: const Duration(milliseconds: 480),
                      child: Text(
                        'WHAT YOU\'VE UNLOCKED',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    for (var i = 0; i < _perks.length; i++)
                      FadeInUp(
                        delay: Duration(milliseconds: 560 + i * 110),
                        child: _Perk(_perks[i]),
                      ),
                  ],
                  if (_receipt != null || until != null) ...[
                    const SizedBox(height: 16),
                    FadeIn(
                      delay: const Duration(milliseconds: 1100),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Text(
                          [
                            ?_receipt,
                            if (until != null) 'Valid until $until',
                          ].join('  •  '),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FadeInUp(
                    delay: const Duration(milliseconds: 1250),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _gold,
                          foregroundColor: _navy,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _isPremium ? 'Start Exploring' : 'Done',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Confetti burst on top; ignores touches.
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _confetti,
                  builder: (_, _) => CustomPaint(
                    painter: _ConfettiPainter(_confetti.value),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Perk extends StatelessWidget {
  final String text;
  const _Perk(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_rounded, color: _gold, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lightweight one-shot confetti (no extra package).
class _ConfettiPainter extends CustomPainter {
  final double t; // 0..1
  _ConfettiPainter(this.t);

  static const _colors = [
    _gold,
    Color(0xFFFF5C8A),
    Color(0xFF4DD4AC),
    Color(0xFF6EA8FF),
    Colors.white,
  ];

  // Fixed seed → same pattern every frame.
  static final List<_Piece> _pieces = () {
    final r = math.Random(7);
    return List.generate(46, (i) {
      return _Piece(
        x: r.nextDouble(),
        delay: r.nextDouble() * 0.35,
        speed: 0.55 + r.nextDouble() * 0.6,
        drift: (r.nextDouble() - 0.5) * 0.25,
        size: 5 + r.nextDouble() * 6,
        spin: (r.nextDouble() - 0.5) * 14,
        color: _colors[i % _colors.length],
      );
    });
  }();

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _pieces) {
      final local = (t - p.delay) / (1 - p.delay);
      if (local <= 0 || local >= 1) continue;
      final dx = (p.x + p.drift * local) * size.width;
      final dy = -20 + local * p.speed * (size.height + 40);
      final opacity = local > 0.8 ? (1 - local) / 0.2 : 1.0;
      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(p.spin * local);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.55,
          ),
          const Radius.circular(1.5),
        ),
        Paint()..color = p.color.withValues(alpha: opacity.clamp(0, 1)),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}

class _Piece {
  final double x, delay, speed, drift, size, spin;
  final Color color;
  const _Piece({
    required this.x,
    required this.delay,
    required this.speed,
    required this.drift,
    required this.size,
    required this.spin,
    required this.color,
  });
}
