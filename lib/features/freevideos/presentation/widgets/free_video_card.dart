import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FreeVideoCard extends StatelessWidget {
  final String title;
  final String thumbnail;
  final int duration;
  final VoidCallback onTap;

  const FreeVideoCard({
    super.key,
    required this.title,
    required this.thumbnail,
    required this.duration,
    required this.onTap,
  });

  String get time =>
      '${duration ~/ 60}:${(duration % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: 65.w,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(2.w),
              child: Stack(
                children: [
                  Image.network(
                    thumbnail,
                    height: 18.h,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    bottom: 1.h,
                    right: 2.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: .5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(1.w),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 1.h),

            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: .5.h),

            Text(
              'FREE',
              style: TextStyle(
                color: cs.primary,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
