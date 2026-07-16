import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Rounded 16:9 hero video for the consultation / webinar screens.
///
/// Pass a YouTube URL (or video id). If empty, shows a tasteful placeholder so
/// the layout never breaks before the real video is provided.
class PromoHeroVideo extends StatefulWidget {
  final String videoUrl;

  const PromoHeroVideo({super.key, required this.videoUrl});

  @override
  State<PromoHeroVideo> createState() => _PromoHeroVideoState();
}

class _PromoHeroVideoState extends State<PromoHeroVideo> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    final id = YoutubePlayer.convertUrlToId(widget.videoUrl) ??
        (widget.videoUrl.trim().isNotEmpty ? widget.videoUrl.trim() : null);
    if (id != null) {
      _controller = YoutubePlayerController(
        initialVideoId: id,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          hideControls: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _controller == null
            ? _placeholder()
            : YoutubePlayer(
                controller: _controller!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Color(0xFFFFD000),
              ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.black.withValues(alpha: 0.25),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow_rounded,
                  color: Color(0xFF0A2066), size: 34),
            ),
            const SizedBox(height: 8),
            Text(
              "Intro video",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
