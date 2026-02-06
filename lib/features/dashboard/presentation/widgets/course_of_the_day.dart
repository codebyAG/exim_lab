import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CourseOfTheDayCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String priceText;
  final String badgeText;
  final String imagePath;
  final VoidCallback onTap;

  const CourseOfTheDayCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.priceText,
    required this.badgeText,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        height: 30.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            colors: isDark
                ? [
                    cs.surface.withValues(alpha: 0.95),
                    cs.surface.withValues(alpha: 0.85),
                  ]
                : [
                    cs.primary.withValues(alpha: 0.95),
                    cs.primary.withValues(alpha: 0.75),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.35),
              blurRadius: 22,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          children: [
            // IMAGE
            Positioned(
              left: -3.w,
              bottom: 0,
              child: imagePath.startsWith('http')
                  ? Image.network(imagePath, width: 44.w, fit: BoxFit.contain)
                  : Image.asset(imagePath, width: 44.w, fit: BoxFit.contain),
            ),

            // CONTENT
            Padding(
              padding: EdgeInsets.fromLTRB(42.w, 3.h, 4.w, 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PromoText('COURSE', color: cs.secondary),
                  _PromoText('OF THE DAY', color: cs.secondary),

                  SizedBox(height: 1.6.h),

                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isDark ? cs.onSurface : cs.onPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 17.sp,
                      height: 1.2,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: (isDark ? cs.onSurface : cs.onPrimary).withValues(
                        alpha: 0.85,
                      ),
                      fontSize: 15.sp,
                      height: 1.4,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 0.8.h,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? cs.secondary : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          priceText,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: isDark ? cs.onSecondary : cs.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          badgeText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: (isDark ? cs.onSurface : cs.onPrimary)
                                .withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// PROMO TEXT
class _PromoText extends StatelessWidget {
  final String text;
  final Color color;

  const _PromoText(this.text, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.04,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.4,
          color: color,
        ),
      ),
    );
  }
}
