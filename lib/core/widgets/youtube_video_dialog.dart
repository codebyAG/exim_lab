import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Plays a premium/one-on-one page video in a dialog.
///
/// YouTube links play inline; anything else is handed to the system browser so
/// a non-YouTube URL never dead-ends. If in-app playback errors out (video
/// unavailable, embedding disabled, region-blocked, etc.), a fallback prompt
/// offers to open the same video externally in the YouTube app/browser.
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
    builder: (_) => _YoutubeVideoDialog(videoId: videoId, videoUrl: videoUrl),
  );
}

class _YoutubeVideoDialog extends StatefulWidget {
  final String videoId;
  final String videoUrl;
  const _YoutubeVideoDialog({required this.videoId, required this.videoUrl});

  @override
  State<_YoutubeVideoDialog> createState() => _YoutubeVideoDialogState();
}

class _YoutubeVideoDialogState extends State<_YoutubeVideoDialog> {
  late final YoutubePlayerController _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    )..addListener(_onPlayerValueChanged);
  }

  void _onPlayerValueChanged() {
    if (_controller.value.hasError && !_hasError) {
      setState(() => _hasError = true);
      _controller.pause();
    }
  }

  Future<void> _openExternally() async {
    await launchUrlString(widget.videoUrl, mode: LaunchMode.externalApplication);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void deactivate() {
    // Stop playback before the route is torn down (see PROJECT_CONTEXT B7).
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.removeListener(_onPlayerValueChanged);
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
            child: _hasError
                ? _PlaybackErrorFallback(onOpenExternally: _openExternally)
                : YoutubePlayer(
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

class _PlaybackErrorFallback extends StatelessWidget {
  final VoidCallback onOpenExternally;
  const _PlaybackErrorFallback({required this.onOpenExternally});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: const Color(0xFF0A0A0A),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white70,
              size: 36,
            ),
            const SizedBox(height: 10),
            const Text(
              "This video couldn't be played here — tap to watch on YouTube",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onOpenExternally,
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: const Text("Watch on YouTube"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC629),
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
