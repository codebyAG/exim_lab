import 'package:exim_lab/features/freevideos/data/models/free_videos_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FreeVideoDetailsScreen extends StatefulWidget {
  final FreeVideoModel video;

  const FreeVideoDetailsScreen({super.key, required this.video});

  @override
  State<FreeVideoDetailsScreen> createState() => _FreeVideoDetailsScreenState();
}

class _FreeVideoDetailsScreenState extends State<FreeVideoDetailsScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(widget.video.videoUrl)!;

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: cs.onSurface),
        title: Text('Free Video', style: theme.textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎬 VIDEO PLAYER
            ClipRRect(
              borderRadius: BorderRadius.circular(3.w),
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: cs.primary,
              ),
            ),

            SizedBox(height: 3.h),

            // 📌 TITLE
            Text(
              widget.video.title,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),

            SizedBox(height: 1.h),

            // 🆓 FREE TAG
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: .6.h,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'FREE VIDEO',
                    style: TextStyle(
                      color: cs.primary,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // 📝 DESCRIPTION
            Text(
              widget.video.description,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.5,
                color: cs.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
