import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PremiumFeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String buttonLabel;
  final Color themeColor;
  final VoidCallback onTap;

  const PremiumFeatureCard({
    super.key,
    required this.title,
    required this.icon,
    required this.buttonLabel,
    required this.themeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16.h,
      height: 16.h,
      margin: EdgeInsets.only(right: 4.w),
      decoration: BoxDecoration(
        color: themeColor, // Solid card color from screenshot
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            // 📦 MAIN ICON AREA
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Subtitle Outline Icon/Pattern if needed
                  Icon(
                    icon,
                    size: 80.sp,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  // Primary Icon
                  Icon(
                    icon,
                    size: 32.sp,
                    color: Colors.white,
                  ),
                ],
              ),
            ),

            // 📝 TITLE
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14.5.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  height: 1.1,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 1.2.h),

            // 🔘 FOOTER STRIP
            Material(
              color: Colors.black.withValues(alpha: 0.15),
              child: InkWell(
                onTap: onTap,
                child: Container(
                  height: 3.8.h,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          buttonLabel.replaceAll(" >", ""),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w700,
                            fontSize: 11.sp,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 14,
                        color: Colors.white70,
                      ),
                    ],
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
