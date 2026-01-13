import 'package:exim_lab/features/freevideos/presentation/states/free_video_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'free_video_card.dart';

class FreeVideosSection extends StatelessWidget {
  const FreeVideosSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FreeVideosState>();

    if (state.isLoading) {
      return SizedBox(
        height: 22.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null) {
      return Padding(padding: EdgeInsets.all(4.w), child: Text(state.error!));
    }

    if (state.videos.isEmpty) return const SizedBox();

    return SizedBox(
      height: 28.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: state.videos.length,
        separatorBuilder: (_, __) => SizedBox(width: 4.w),
        itemBuilder: (context, index) {
          final v = state.videos[index];
          return FreeVideoCard(video: v);
        },
      ),
    );
  }
}
