import 'package:exim_lab/core/constants/appcardshadow.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class QuickCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const QuickCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 15.h, // ✅ responsive height
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: appCardShadow(context),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 🔹 TOP CURVED HALF
            Container(
              height: 7.h,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.9),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
            ),

            // 🔹 ICON ON CURVE LINE
            Positioned(
              top: 3.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: 6.h,
                  width: 6.h,
                  decoration: BoxDecoration(
                    color: cs.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: cs.primary.withOpacity(0.35),
                      width: 2,
                    ),
                  ),
                  child: Icon(icon, size: 2.6.h, color: cs.primary),
                ),
              ),
            ),

            // 🔹 CONTENT
            Padding(
              padding: EdgeInsets.fromLTRB(2.w, 9.h, 2.w, 1.2.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: cs.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.6.h),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 14.sp,
                      color: cs.onSurface.withOpacity(0.65),
                    ),
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
