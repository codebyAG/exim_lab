import 'package:exim_lab/features/freevideos/data/models/free_videos_model.dart';
import 'package:exim_lab/features/freevideos/presentation/screens/free_videos_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';

class FreeVideoCard extends StatelessWidget {
  final FreeVideoModel video;

  const FreeVideoCard({super.key, required this.video});

  String get time =>
      '${video.durationSeconds ~/ 60}:${(video.durationSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: 65.w,
      child: GestureDetector(
        onTap: () => _openDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎥 THUMBNAIL WITH PLAY BUTTON
            ClipRRect(
              borderRadius: BorderRadius.circular(2.w),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    video.thumbnailUrl,
                    height: 18.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  // ▶ PLAY BUTTON
                  Container(
                    height: 7.h,
                    width: 7.h,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 25.sp,
                      color: Colors.white,
                    ),
                  ),

                  // ⏱ DURATION
                  Positioned(
                    bottom: 1.h,
                    right: 2.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: .4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(1.w),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 1.h),

            // 📌 TITLE
            Text(
              video.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),

            SizedBox(height: .5.h),

            // 🆓 FREE TAG
            Text(
              'FREE',
              style: TextStyle(
                color: cs.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetails(BuildContext context) {
    AppNavigator.push(context, FreeVideoDetailsScreen(video: video));
  }
}
