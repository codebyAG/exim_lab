import 'package:exim_lab/common/widgets/premium_widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

const _gold = Color(0xFFFFD000);
const _goldDeep = Color(0xFFCC9E00);
const _cardBg = Color(0xFF030E30);

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
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 46.w,
        height: 25.h,
        margin: EdgeInsets.only(right: 4.w),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isLocked
                ? Colors.white.withValues(alpha: 0.1)
                : _gold.withValues(alpha: 0.22),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: themeColor.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: themeColor.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Center(
                        child: painter != null
                            ? SizedBox(
                                width: 32,
                                height: 32,
                                child: CustomPaint(painter: painter),
                              )
                            : icon != null
                            ? SafePremiumIcon(
                                icon: isLocked
                                    ? Icons.lock_outline_rounded
                                    : icon,
                                size: 28,
                                color: themeColor,
                              )
                            : null,
                      ),
                    ),
                    const Spacer(),
                    if (isLocked)
                      Icon(
                        Icons.lock_rounded,
                        color: Colors.white.withValues(alpha: 0.4),
                        size: 20,
                      ),
                  ],
                ),
                const Spacer(),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15.5.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    gradient: isLocked
                        ? null
                        : const LinearGradient(
                            colors: [_gold, _goldDeep],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    color: isLocked
                        ? Colors.white.withValues(alpha: 0.08)
                        : null,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    buttonLabel,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isLocked
                          ? Colors.white70
                          : const Color(0xFF200058),
                      fontWeight: FontWeight.w800,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
