import 'package:exim_lab/features/shorts/data/models/short_model.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _isLiked = false;
  bool _isSaved = false;

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
    if (_initialized && mounted && !_controller.value.isFullScreen) {
      // Added mounted check again for safety
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    }
  }

  @override
  void didUpdateWidget(covariant ShortsPlayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_initialized || !mounted || _isDisposed) return; // Safety check

    if (widget.isVisible && !oldWidget.isVisible) {
      _controller.play();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _controller.pause();
    }
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (!_initialized || !mounted || _isDisposed) return;

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
        if (!_initialized || !mounted || _isDisposed) return;

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
              thumbnail: Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
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

            // Right-side action bar (like / comment / share / save)
            Positioned(
              right: 3.w,
              bottom: 5.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _actionButton(
                    icon: _isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: _isLiked ? const Color(0xFFFF3B5C) : Colors.white,
                    label: _formatCount(
                      widget.short.likeCount + (_isLiked ? 1 : 0),
                    ),
                    onTap: () => setState(() => _isLiked = !_isLiked),
                  ),
                  SizedBox(height: 2.2.h),
                  _actionButton(
                    icon: Icons.mode_comment_outlined,
                    color: Colors.white,
                    label: _formatCount(
                      (widget.short.viewCount * 0.03).round(),
                    ),
                    onTap: () {},
                  ),
                  SizedBox(height: 2.2.h),
                  _actionButton(
                    icon: Icons.reply_rounded,
                    color: Colors.white,
                    label: 'Share',
                    onTap: _shareShort,
                  ),
                  SizedBox(height: 2.2.h),
                  _actionButton(
                    icon: _isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: _isSaved ? const Color(0xFFFFD000) : Colors.white,
                    label: 'Save',
                    onTap: () => setState(() => _isSaved = !_isSaved),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 30,
            shadows: const [Shadow(blurRadius: 8, color: Colors.black54)],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return '$count';
  }

  Future<void> _shareShort() async {
    final uri = Uri.tryParse(widget.short.videoUrl);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
