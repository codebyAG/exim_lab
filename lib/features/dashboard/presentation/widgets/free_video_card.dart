import 'package:exim_lab/features/dashboard/presentation/painters/dashboard_icons_painter.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FreeVideoCard extends StatelessWidget {
  final String title;
  final String? thumbnailUrl;
  final int durationSeconds;
  final String views; // "128K views"
  final String timeAgo; // "6 months ago"
  final VoidCallback? onTap;

  const FreeVideoCard({
    super.key,
    required this.title,
    this.thumbnailUrl,
    required this.durationSeconds,
    required this.views,
    required this.timeAgo,
    this.onTap,
  });

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor();
    return "$minutes min";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 75.w,
        margin: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: const Color(0xFF030E30), // Deep Navy
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ THUMBNAIL LAYER
            Stack(
              children: [
                Container(
                  height: 18.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF061540), Color(0xFF0A2066)],
                    ),
                    image: thumbnailUrl != null && thumbnailUrl!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(thumbnailUrl!),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withValues(alpha: 0.4),
                              BlendMode.darken,
                            ),
                          )
                        : null,
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: Size(160 * 0.4, 90 * 0.4), // Scale down based on reference
                      painter: VideoPlayPainter(),
                    ),
                  ),
                ),
                // "FREE" Badge
                Positioned(
                  top: 1.5.h,
                  left: 3.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1ED760), // Spotify-ish Vibrant Green
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1ED760).withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      "FREE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                // Duration Badge
                Positioned(
                  bottom: 1.5.h,
                  right: 3.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.6.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 10.sp, color: Colors.white70),
                        SizedBox(width: 1.w),
                        Text(
                          _formatDuration(durationSeconds),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 📝 CONTENT LAYER
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.2.h),
                  Row(
                    children: [
                      Icon(Icons.remove_red_eye_outlined, size: 11.sp, color: Colors.white54),
                      SizedBox(width: 1.5.w),
                      Text(
                        "$views · $timeAgo",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
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
