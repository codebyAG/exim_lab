import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// 🎨 HELPER FOR RENDERING BOTH MATERIAL & FONTAWESOME ICONS
class SafePremiumIcon extends StatelessWidget {
  final dynamic icon;
  final double? size;
  final Color? color;

  const SafePremiumIcon({super.key, required this.icon, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    if (icon is FaIconData) {
      return FaIcon(icon as FaIconData, size: size, color: color);
    }
    return Icon(icon as IconData?, size: size, color: color);
  }
}

// 🎨 CUSTOM PAINTER FOR THE PREMIUM CARD WAVE ACCENT
class PremiumCardWavePainter extends CustomPainter {
  final Color color;
  PremiumCardWavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
// Wave color is a balanced shade (0.4) for visibility and clarity

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.1,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.9,
      size.width,
      size.height * 0.4,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
