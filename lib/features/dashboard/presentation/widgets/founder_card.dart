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
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.2.h),
      child: FadeInUp(
        duration: const Duration(milliseconds: 1000),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF1E5FFF).withValues(alpha: 0.35),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1040C1).withValues(alpha: 0.45),
                blurRadius: 40,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // 🎨 PREMIUM GRADIENT BACKGROUND
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF0A2066),
                          Color(0xFF1040C1),
                        ],
                      ),
                    ),
                  ),
                ),

                // 🌐 WORLD MAP WATERMARK
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MapWatermarkPainter(),
                  ),
                ),

                // 📏 DIAGONAL STRIPES PATTERN
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.02,
                    child: CustomPaint(
                      painter: _DiagonalStripesPainter(),
                    ),
                  ),
                ),

                // 📦 CONTENT
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🎖 TOP BADGE BAR
                    Container(
                      color: Colors.black.withValues(alpha: 0.35),
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.h,
                      ),
                      child: Row(
                        children: [
                          _buildPillBadge("✓  VERIFIED", null, isVerified: true),
                          SizedBox(width: 2.w),
                          _buildPillBadge(
                            "⭐  48+ YRS EXPERIENCE",
                            null,
                            isGold: true,
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Row(
                        children: [
                          // 👱‍♂️ AVATAR WITH GOLD RING & GLOW
                          SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // INNER GLOW
                                Container(
                                  width: 20.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFF5A800)
                                            .withValues(alpha: 0.45),
                                        blurRadius: 24,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                // BORDER RING
                                Container(
                                  width: 22.w,
                                  height: 22.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFF5A800),
                                      width: 3,
                                    ),
                                  ),
                                ),
                                // AVATAR
                                Container(
                                  width: 18.w,
                                  height: 18.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF3A6BC8),
                                        Color(0xFF1040C1),
                                      ],
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/ashok_sir_image.png',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 10.w,
                                              ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 4.w),
                          // INFO
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mr. Ashok Gupta\nKinkkar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                    fontFamily: 'Plus Jakarta Sans',
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  "Founder & Global Mentor",
                                  style: TextStyle(
                                    color: const Color(0xFFF5A800),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 1.5.h),
                                IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 3,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFC8151B),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Expanded(
                                        child: Text(
                                          "\"Empowering India\nin Global Trade\"",
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.7,
                                            ),
                                            fontSize: 12.sp,
                                            fontStyle: FontStyle.italic,
                                            height: 1.6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🔘 RED FOOTER CTA
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap:
                            () => _showAboutUsBottomSheet(
                              context,
                              t,
                              cs,
                              theme,
                            ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 1.8.h,
                          ),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFC8151B), Color(0xFFFF2D35)],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Know More About the Mentor",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillBadge(
    String text,
    Color? color, {
    bool isVerified = false,
    bool isGold = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color:
            isVerified
                ? Colors.white.withValues(alpha: 0.12)
                : isGold
                ? const Color(0xFFF5A800).withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color:
              isVerified
                  ? Colors.white.withValues(alpha: 0.2)
                  : isGold
                  ? const Color(0xFFF5A800).withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isGold ? const Color(0xFFFFD000) : Colors.white,
          fontSize: 9.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.06,
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
      builder:
          (context) => Container(
            height: 70.h,
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
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
                        icon: const Icon(Icons.close_rounded),
                        color: cs.onSurface,
                        style: IconButton.styleFrom(
                          backgroundColor: cs.outlineVariant.withValues(
                            alpha: 0.3,
                          ),
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
                              backgroundColor: cs.primaryContainer.withValues(
                                alpha: 0.3,
                              ),
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
                            color: cs.onSurface.withValues(alpha: 0.7),
                            height: 1.6,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        _buildSectionHeader(cs, theme, "Our Commitment"),
                        SizedBox(height: 1.h),
                        Text(
                          t.translate('about_us_text_full'),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.7),
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
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}

// 🎨 WATERMARK PAINTER
class _MapWatermarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final center = Offset(size.width * 0.85, size.height * 0.35);
    const radius = 60.0;

    // Globe ellipses
    canvas.drawCircle(center, radius, paint);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: radius * 1.1, height: radius * 2),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: center, width: radius * 2, height: radius * 0.75),
      paint,
    );
    canvas.drawLine(
      center - const Offset(radius, 0),
      center + const Offset(radius, 0),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 📏 STRIPES PAINTER
class _DiagonalStripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    for (double i = -size.height; i < size.width; i += 12) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
