import 'package:exim_lab/features/shorts/data/models/short_model.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:sizer/sizer.dart';

class ShortsPlayerItem extends StatefulWidget {
  final ShortModel short;
  final bool isVisible;

  const ShortsPlayerItem({
    super.key,
    required this.short,
    required this.isVisible,
  });

  @override
  State<ShortsPlayerItem> createState() => _ShortsPlayerItemState();
}

class _ShortsPlayerItemState extends State<ShortsPlayerItem> {
  late YoutubePlayerController _controller;
  bool _initialized = false;

  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    String? videoId = YoutubePlayer.convertUrlToId(widget.short.videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: true,
        hideControls: true,
        enableCaption: false,
        isLive: false,
        forceHD: false,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_initialized && mounted) {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    }
  }

  @override
  void didUpdateWidget(covariant ShortsPlayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _controller.play();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _controller.pause();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.short.id),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.65) {
          _controller.play();
        } else {
          _controller.pause();
        }
      },
      child: GestureDetector(
        onTap: _togglePlay,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video Player
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.red,
              onReady: () {
                _initialized = true;
                if (widget.isVisible) _controller.play();
              },
              bottomActions: const [], // Hide default controls
            ),

            // Play/Pause Overlay
            if (!_isPlaying)
              const Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 60,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                ),
              ),

            // Overlay UI (Title, Views, etc.)
            Positioned(
              bottom: 2.h,
              left: 4.w,
              right: 15.w, // Leave space for side actions if added
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ... text widgets
                  Text(
                    widget.short.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp, // Increased size
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.short.description, // Replaced views with description
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.sp,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
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
