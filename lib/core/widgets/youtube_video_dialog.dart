import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Plays a premium/one-on-one page video in a dialog.
///
/// YouTube links play inline; anything else is handed to the system browser so
/// a non-YouTube URL never dead-ends.
Future<void> showYoutubeVideoDialog(BuildContext context, String videoUrl) async {
  if (videoUrl.isEmpty) return;

  final videoId = YoutubePlayer.convertUrlToId(videoUrl);
  if (videoId == null) {
    await launchUrlString(videoUrl, mode: LaunchMode.externalApplication);
    return;
  }

  await showDialog<void>(
    context: context,
    barrierColor: Colors.black87,
    builder: (_) => _YoutubeVideoDialog(videoId: videoId),
  );
}

class _YoutubeVideoDialog extends StatefulWidget {
  final String videoId;
  const _YoutubeVideoDialog({required this.videoId});

  @override
  State<_YoutubeVideoDialog> createState() => _YoutubeVideoDialogState();
}

class _YoutubeVideoDialogState extends State<_YoutubeVideoDialog> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  @override
  void deactivate() {
    // Stop playback before the route is torn down (see PROJECT_CONTEXT B7).
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, color: Colors.white),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: const Color(0xFFFFC629),
            ),
          ),
        ],
      ),
    );
  }
}
