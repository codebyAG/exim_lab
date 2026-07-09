import 'package:exim_lab/common/widgets/premium_widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/core/theme/app_colors.dart';

class ToolCard extends StatelessWidget {
  final dynamic icon;
  final CustomPainter? painter;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onTap;
  final bool isLocked;
  final Color themeColor;
  final bool isLight;

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
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    // Light/dark aware colors (dashboard uses dark, Tools screen uses light)
    final Color cardColor =
        isLight ? Colors.white : const Color(0xFF030E30);
    final Color titleColor = isLight ? AppColors.navy : Colors.white;
    final Color subtitleColor = isLight
        ? Colors.black.withValues(alpha: 0.5)
        : Colors.white.withValues(alpha: 0.5);
    final Color borderColor = isLight
        ? themeColor.withValues(alpha: 0.30)
        : Colors.white.withValues(alpha: 0.1);
    final Color pillBg = isLight
        ? themeColor.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.1);
    final Color pillText = isLight ? themeColor : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 46.w,
        height: 28.h,
        margin: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: borderColor,
            width: isLight ? 1.5 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isLight
                  ? themeColor.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.3),
              blurRadius: isLight ? 18 : 15,
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
                            color: titleColor,
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
                            color: subtitleColor,
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
                        color: pillBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isLight
                              ? themeColor.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              buttonLabel,
                              style: TextStyle(
                                color: pillText,
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
