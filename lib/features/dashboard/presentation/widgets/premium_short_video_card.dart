import 'package:cached_network_image/cached_network_image.dart';
import 'package:exim_lab/features/dashboard/presentation/painters/dashboard_icons_painter.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PremiumShortVideoCard extends StatelessWidget {
  final String title;
  final int viewCount;
  final int durationSeconds;
  final List<Color> gradientColors;
  final String? thumbnailUrl;
  final VoidCallback? onTap;

  const PremiumShortVideoCard({
    super.key,
    required this.title,
    required this.viewCount,
    required this.durationSeconds,
    required this.gradientColors,
    this.thumbnailUrl,
    this.onTap,
  });

  String _formatViews(int views) {
    if (views >= 1000) {
      return "${(views / 1000).toStringAsFixed(1)}K";
    }
    return views.toString();
  }

  String _formatDuration(int seconds) {
    final m = (seconds / 60).floor();
    final s = seconds % 60;
    return "$m:${s.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.w,
        margin: EdgeInsets.only(right: 3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ VERTICAL CARD
            Container(
              height: 22.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                image: thumbnailUrl != null && thumbnailUrl!.isNotEmpty
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(thumbnailUrl!),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          gradientColors[0].withValues(alpha: 0.4),
                          BlendMode.darken,
                        ),
                      )
                    : null,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors[0].withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Patterns at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CustomPaint(
                      size: Size(38.w, 4.h),
                      painter: ShortsPatternPainter(),
                    ),
                  ),
                  // Centered Play
                  Center(
                    child: CustomPaint(
                      size: Size(32, 32),
                      painter: ShortsPlayPainter(),
                    ),
                  ),
                  // View Count Badge
                  Positioned(
                    top: 1.2.h,
                    left: 2.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.remove_red_eye_rounded, size: 9.sp, color: Colors.white),
                          SizedBox(width: 1.w),
                          Text(
                            _formatViews(viewCount),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Duration Badge
                  Positioned(
                    bottom: 1.2.h,
                    right: 2.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _formatDuration(durationSeconds),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.2.h),
            // 📝 TITLE BELOW
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
