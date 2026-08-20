import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

const _gold = Color(0xFFFFD000);
const _goldDeep = Color(0xFFCC9E00);
const _cardBg = Color(0xFF030E30);

class PremiumActionCard extends StatelessWidget {
  final IconData? icon;
  final CustomPainter? painter;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool isLocked;

  const PremiumActionCard({
    super.key,
    this.icon,
    this.painter,
    required this.label,
    required this.onTap,
    required this.color,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 17.h,
        height: 17.h,
        margin: EdgeInsets.only(right: 4.w),
        padding: const EdgeInsets.all(14),
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
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withValues(alpha: 0.35)),
                  ),
                  child: Center(
                    child: painter != null
                        ? SizedBox(
                            width: 27,
                            height: 27,
                            child: CustomPaint(painter: painter),
                          )
                        : icon != null
                        ? Icon(icon, size: 25, color: color)
                        : null,
                  ),
                ),
                const Spacer(),
                if (isLocked)
                  Icon(
                    Icons.lock_rounded,
                    color: Colors.white.withValues(alpha: 0.4),
                    size: 19,
                  ),
              ],
            ),
            const Spacer(),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15.sp,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            SizedBox(height: 0.8.h),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: isLocked
                    ? null
                    : const LinearGradient(
                        colors: [_gold, _goldDeep],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                color: isLocked ? Colors.white.withValues(alpha: 0.08) : null,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                isLocked ? "Locked" : "Start >",
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isLocked ? Colors.white70 : const Color(0xFF200058),
                  fontWeight: FontWeight.w800,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
