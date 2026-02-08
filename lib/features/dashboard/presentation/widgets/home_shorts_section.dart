import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/shorts/presentation/providers/shorts_provider.dart';
import 'package:exim_lab/features/shorts/presentation/screens/shorts_feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:exim_lab/localization/app_localization.dart';

class HomeShortsSection extends StatelessWidget {
  const HomeShortsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShortsProvider>(
      builder: (context, provider, child) {
        if (provider.shorts.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              child: Text(
                AppLocalizations.of(context).translate('shorts'),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 25.h, // Height for vertical thumbnails
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                scrollDirection: Axis.horizontal,
                itemCount: provider.shorts.length,
                separatorBuilder: (_, __) => SizedBox(width: 3.w),
                itemBuilder: (context, index) {
                  final short = provider.shorts[index];
                  String? videoId = YoutubePlayer.convertUrlToId(
                    short.videoUrl,
                  );
                  String thumbnailUrl = videoId != null
                      ? 'https://img.youtube.com/vi/$videoId/0.jpg'
                      : '';

                  return GestureDetector(
                    onTap: () {
                      AppNavigator.push(
                        context,
                        ShortsFeedScreen(initialIndex: index),
                      );
                    },
                    child: Container(
                      width:
                          15.h *
                          (9 / 16), // 9:16 Aspect Ratio width based on height
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        image: thumbnailUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(thumbnailUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 1.h,
                            left: 1.w,
                            right: 1.w,
                            child: Text(
                              short.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.bold,
                                shadows: const [
                                  Shadow(blurRadius: 2, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                          const Center(
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
