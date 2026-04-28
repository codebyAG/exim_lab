import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PremiumFeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final CustomPainter? painter;
  final String buttonLabel;
  final Color themeColor;
  final VoidCallback onTap;
  final bool isLocked;

  const PremiumFeatureCard({
    super.key,
    required this.title,
    required this.icon,
    this.painter,
    required this.buttonLabel,
    required this.themeColor,
    required this.onTap,
    this.isLocked = false,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Column(
            children: [
              // 📦 MAIN ICON AREA
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Subtitle Outline Icon/Pattern if needed
                    painter != null
                        ? SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: CustomPaint(painter: painter),
                          )
                        : Icon(
                            icon,
                            size: 80.sp,
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                    // Primary Icon (Only show if no painter)
                    if (painter == null)
                      Icon(
                        icon,
                        size: 32.sp,
                        color: Colors.white,
                      ),
                    if (isLocked)
                      Positioned(
                        top: 2.h,
                        right: 2.h,
                        child: Icon(
                          Icons.lock_rounded,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 16,
                        ),
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
              Container(
                height: 3.8.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
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
            ],
          ),
        ),
      ),
    );
  }
}
