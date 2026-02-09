import 'package:cached_network_image/cached_network_image.dart';

import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/shorts/presentation/providers/shorts_provider.dart';
import 'package:exim_lab/features/shorts/presentation/screens/shorts_feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:exim_lab/localization/app_localization.dart';

class HomeShortsSection extends StatefulWidget {
  const HomeShortsSection({super.key});

  @override
  State<HomeShortsSection> createState() => _HomeShortsSectionState();
}

class _HomeShortsSectionState extends State<HomeShortsSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider = context.read<ShortsProvider>();
        if (provider.shorts.isEmpty && !provider.isLoading) {
          provider.fetchShorts();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShortsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return SizedBox(
            height: 28.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

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
              height: 28.h, // Increased height
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                scrollDirection: Axis.horizontal,
                itemCount: provider.shorts.length > 5
                    ? 5
                    : provider.shorts.length,
                separatorBuilder: (context, index) => SizedBox(width: 3.w),
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
                      width: 35.w, // Increased width (was dynamic)
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        image: thumbnailUrl.isNotEmpty
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(thumbnailUrl),
                                fit: BoxFit.cover,
                                onError: (exception, stackTrace) {
                                  // log("Error loading thumbnail: $exception");
                                },
                              )
                            : null,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 1.5.h,
                            left: 2.w,
                            right: 2.w,
                            child: Text(
                              short.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                                shadows: const [
                                  Shadow(blurRadius: 4, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                          const Center(
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: 40, // Increased size
                              shadows: [
                                Shadow(blurRadius: 5, color: Colors.black45),
                              ],
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
