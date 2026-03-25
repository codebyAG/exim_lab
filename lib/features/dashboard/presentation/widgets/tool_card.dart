import 'package:exim_lab/common/widgets/premium_widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ToolCard extends StatelessWidget {
  final dynamic icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onTap;
  final bool isLocked;
  final Color themeColor;

  const ToolCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonLabel = "Open Tool >", // Default label
    required this.onTap,
    this.isLocked = false,
    this.themeColor = const Color(0xFF0D47A1), // Default Navy
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.w,
      height: 26.h,
      margin: EdgeInsets.only(right: 4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // 🌊 BOTTOM ACCENT WAVE
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 10.h,
              child: CustomPaint(
                painter: PremiumCardWavePainter(color: themeColor),
              ),
            ),

            // 📦 DYNAMIC CONTENT COLUMN
            Padding(
              padding: EdgeInsets.fromLTRB(3.w, 1.5.h, 3.w, 1.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 📝 TITLE
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF001A3D),
                      fontWeight: FontWeight.w800,
                      fontSize: 14.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // 🎨 ICON AREA
                  Expanded(
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 35.sp,
                            height: 35.sp,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: themeColor.withValues(alpha: 0.15),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                          ),
                          SafePremiumIcon(
                            icon: isLocked ? Icons.lock_outline_rounded : icon,
                            size: 36.sp,
                            color: themeColor.withValues(alpha: 0.9),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 🔘 ACTION PILL
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 0.6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                buttonLabel,
                                style: TextStyle(
                                  color: themeColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (buttonLabel.contains(">")) ...[
                              SizedBox(width: 1.w),
                              Icon(
                                Icons.chevron_right_rounded,
                                size: 14,
                                color: themeColor,
                              ),
                            ],
                          ],
                        ),
                      ),
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
