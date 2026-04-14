import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';
import 'package:exim_lab/localization/app_localization.dart';

class FounderCard extends StatelessWidget {
  const FounderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final t = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      child: FadeInLeft(
        duration: const Duration(milliseconds: 800),
        child: SizedBox(
          width: 100.w, // Fixed from double.infinity to prevent crash
          height: 26.h,
          child: Stack(
            children: [
              // 🎨 CUSTOM DRAWN BACKGROUND
              CustomPaint(
                size: Size(100.w, 31.h), // Fixed double.infinity crash
                painter: _SirCardPainter(cs: cs),
              ),

              // 📦 CONTENT LAYER
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    // 👱‍♂️ PROFILE WITH ADAPTIVE GLOW RING
                    SizedBox(
                      width: 28.w,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: Size(25.w, 25.w),
                            painter: _ProfileGlowPainter(cs: cs),
                          ),
                          Container(
                            width: 19.w,
                            height: 19.w,
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 9.w,
                              backgroundImage: const AssetImage(
                                'assets/ashok_sir_image.png',
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 4.w),
                    // 📝 TEXT CONTENT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 🏅 BADGES
                          Row(
                            children: [
                              _buildPillBadge("VERIFIED", cs.primary),
                              SizedBox(width: 2.w),
                              _buildPillBadge(
                                "48+ YEARS EXP.",
                                null,
                                isWhite: true,
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "Mr. Ashok Gupta Kinkkar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          Text(
                            "Founder & Global Mentor",
                            style: TextStyle(
                              color: const Color(0xFFFFD700), // Gold
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "\"Empowering India in Global Trade\"",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9), // Changed withValues -> withOpacity for stability
                              fontSize: 12.sp,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 🔘 RED "KNOW MORE" BUTTON
              Positioned(
                bottom: 1.h,
                right: 2.w,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showAboutUsBottomSheet(context, t, cs, theme),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 1.2.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD32F2F).withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Know More ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 14.sp,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillBadge(String text, Color? color, {bool isWhite = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
        vertical: 0.5.h,
      ),
      decoration: BoxDecoration(
        color: isWhite
            ? Colors.white
            : (color?.withValues(alpha: 0.2) ?? Colors.white10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isWhite
              ? Colors.white
              : (color?.withValues(alpha: 0.3) ?? Colors.white24),
          width: 0.8,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isWhite ? const Color(0xFF001A3D) : Colors.white,
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showAboutUsBottomSheet(
    BuildContext context,
    AppLocalizations t,
    ColorScheme cs,
    ThemeData theme,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            SizedBox(height: 1.5.h),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 0.8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.translate('about_us_title'),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: cs.onSurfaceVariant),
                    style: IconButton.styleFrom(
                      backgroundColor: cs.surfaceContainerHighest,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: cs.primaryContainer.withValues(alpha: 0.3),
                          backgroundImage: const AssetImage(
                            'assets/ashok_sir_image.png',
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.translate('about_sir_title'),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: cs.onSurface,
                                ),
                              ),
                              Text(
                                t.translate('about_sir_desc'),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    _buildSectionHeader(cs, theme, "Our Vision"),
                    SizedBox(height: 1.h),
                    Text(
                      t.translate('about_us_text'),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 1.2.h),
                    _buildSectionHeader(cs, theme, "Our Commitment"),
                    SizedBox(height: 1.h),
                    Text(
                      t.translate('about_us_text_full'),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ColorScheme cs, ThemeData theme, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}

// 🎨 CUSTOM PAINTER FOR NAVY FOUNDER CARD
class _SirCardPainter extends CustomPainter {
  final ColorScheme cs;
  _SirCardPainter({required this.cs});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [cs.primary, const Color(0xFF001A3D)],
      ).createShader(Offset.zero & size);

    final path = Path();
    const r = 24.0; // Corner radius

    // 📐 TRACING THE PREMIUM SHAPE
    path.moveTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);
    path.lineTo(size.width - r, 0);
    path.quadraticBezierTo(size.width, 0, size.width, r);
    path.lineTo(
      size.width,
      size.height * 0.65,
    ); // Start Step Down slightly earlier
    path.quadraticBezierTo(
      size.width,
      size.height * 0.75,
      size.width - r,
      size.height * 0.75,
    );
    path.lineTo(
      size.width * 0.55 + r,
      size.height * 0.75,
    ); // Moved left to 0.55
    path.quadraticBezierTo(
      size.width * 0.55,
      size.height * 0.75,
      size.width * 0.55,
      size.height * 0.85,
    );
    path.lineTo(size.width * 0.55, size.height - r);
    path.quadraticBezierTo(
      size.width * 0.55,
      size.height,
      size.width * 0.55 - r,
      size.height,
    );
    path.lineTo(r, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - r);
    path.close();

    // Draw Drop Shadow
    canvas.drawShadow(
      path.shift(const Offset(0, 10)),
      Colors.black54,
      15,
      true,
    );

    // Draw Background
    canvas.drawPath(path, paint);

    // Draw Globe/Grid lines (Subtle)
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width * 0.25, size.height * 0.5);
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, i * 35.0, gridPaint);
    }
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width * 0.6, size.height * 0.5),
      gridPaint,
    );

    // Draw Bevel Border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.4),
          Colors.transparent,
          Colors.white.withValues(alpha: 0.15),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 🎨 CUSTOM PAINTER FOR THE GLOWING PROFILE RING
class _ProfileGlowPainter extends CustomPainter {
  final ColorScheme cs;
  _ProfileGlowPainter({required this.cs});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer Glow
    final glowPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
      ..shader = SweepGradient(
        colors: [
          const Color(0xFFD32F2F),
          Colors.white,
          const Color(0xFF2196F3),
          const Color(0xFFD32F2F),
        ],
        stops: const [0.0, 0.4, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius - 4, glowPaint);

    // Solid Ring
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = Colors.white.withValues(alpha: 0.9);
    canvas.drawCircle(center, radius - 7, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
