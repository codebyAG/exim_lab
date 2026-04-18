import 'package:exim_lab/common/widgets/premium_widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ToolCard extends StatelessWidget {
  final dynamic icon;
  final CustomPainter? painter;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onTap;
  final bool isLocked;
  final Color themeColor;

  const ToolCard({
    super.key,
    this.icon,
    this.painter,
    required this.title,
    required this.subtitle,
    this.buttonLabel = "Open Tool >",
    required this.onTap,
    this.isLocked = false,
    this.themeColor = const Color(0xFF0D47A1),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 46.w,
        height: 28.h,
        margin: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: const Color(0xFF030E30), // Deep Premium Navy
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
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
                height: 12.h,
                child: CustomPaint(
                  painter: PremiumCardWavePainter(
                    color: themeColor.withValues(alpha: 0.4),
                  ),
                ),
              ),

              // 📦 DYNAMIC CONTENT COLUMN
              Padding(
                padding: EdgeInsets.fromLTRB(3.w, 2.h, 3.w, 1.5.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 📝 TITLE & SUBTITLE
                    Column(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14.sp,
                            fontFamily: 'Plus Jakarta Sans',
                            letterSpacing: -0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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
                                    color: themeColor.withValues(alpha: 0.2),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                            if (painter != null)
                              SizedBox(
                                width: 38.sp,
                                height: 38.sp,
                                child: CustomPaint(painter: painter),
                              )
                            else if (icon != null)
                              SafePremiumIcon(
                                icon: isLocked
                                    ? Icons.lock_outline_rounded
                                    : icon,
                                size: 34.sp,
                                color: themeColor.withValues(alpha: 0.95),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // 🔘 GLASS ACTION PILL
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 0.8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              buttonLabel,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 11.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 🔒 LOCK OVERLAY (SUBTLE)
              if (isLocked)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.2),
                    child: const Center(
                      child: Icon(
                        Icons.lock_rounded,
                        color: Colors.white54,
                        size: 24,
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
}
