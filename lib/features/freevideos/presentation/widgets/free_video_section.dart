import 'package:exim_lab/features/freevideos/data/models/free_videos_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'free_video_card.dart';

class FreeVideosSection extends StatelessWidget {
  final List<FreeVideoModel> videos;
  const FreeVideosSection({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) return const SizedBox();

    return SizedBox(
      height: 28.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: videos.length,
        separatorBuilder: (context, index) => SizedBox(width: 4.w),
        itemBuilder: (context, index) {
          final v = videos[index];
          return FreeVideoCard(video: v);
        },
      ),
    );
  }
}
