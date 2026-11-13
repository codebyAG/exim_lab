import 'dart:io';

import 'package:exim_lab/features/app_content/data/models/app_content_models.dart';
import 'package:exim_lab/features/app_content/presentation/providers/app_content_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Plays a manifest video from its LOCAL cached file.
///
/// If the file isn't on disk yet (or vanished), it falls back to the URL for
/// this play and kicks off the download in the background so the next play is
/// local. Pauses automatically when scrolled off-screen.
class CachedVideoView extends StatefulWidget {
  final MediaItem item;
  final bool autoPlay;
  final bool loop;
  final bool muted;
  final bool showControls;
  final BoxFit fit;

  const CachedVideoView({
    super.key,
    required this.item,
    this.autoPlay = true,
    this.loop = true,
    this.muted = true,
    this.showControls = false,
    this.fit = BoxFit.cover,
  });

  @override
  State<CachedVideoView> createState() => _CachedVideoViewState();
}

class _CachedVideoViewState extends State<CachedVideoView> {
  VideoPlayerController? _controller;
  bool _failed = false;
  bool _visible = true;
  late bool _muted = widget.muted;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(CachedVideoView old) {
    super.didUpdateWidget(old);
    // Re-uploaded video: same id, new checksum.
    if (old.item.id != widget.item.id ||
        old.item.checksum != widget.item.checksum) {
      _disposeController();
      _init();
    }
  }

  Future<void> _init() async {
    final content = context.read<AppContentProvider>();
    final local = content.fileFor(widget.item);

    VideoPlayerController c;
    if (local != null) {
      c = VideoPlayerController.file(local);
    } else {
      c = VideoPlayerController.networkUrl(Uri.parse(widget.item.url));
      content.ensure(widget.item); // cache it in the background for next time
    }

    try {
      await c.initialize();
    } catch (_) {
      await c.dispose();
      // Cached file may be corrupt: retry once from the network.
      if (local != null && mounted) {
        try {
          c = VideoPlayerController.networkUrl(Uri.parse(widget.item.url));
          await c.initialize();
        } catch (_) {
          await c.dispose();
          if (mounted) setState(() => _failed = true);
          return;
        }
      } else {
        if (mounted) setState(() => _failed = true);
        return;
      }
    }

    if (!mounted) {
      await c.dispose();
      return;
    }
    await c.setLooping(widget.loop);
    await c.setVolume(_muted ? 0 : 1);
    setState(() {
      _controller = c;
      _failed = false;
    });
    if (widget.autoPlay && _visible) await c.play();
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  void _togglePlay() {
    final c = _controller;
    if (c == null) return;
    setState(() => c.value.isPlaying ? c.pause() : c.play());
  }

  void _toggleMute() {
    final c = _controller;
    if (c == null) return;
    setState(() {
      _muted = !_muted;
      c.setVolume(_muted ? 0 : 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    final ready = c != null && c.value.isInitialized;

    return VisibilityDetector(
      key: Key('cached-video-${widget.item.id}'),
      onVisibilityChanged: (info) {
        _visible = info.visibleFraction > 0.5;
        final ctl = _controller;
        if (ctl == null || !ctl.value.isInitialized) return;
        if (!_visible && ctl.value.isPlaying) {
          ctl.pause();
        } else if (_visible && widget.autoPlay && !ctl.value.isPlaying) {
          ctl.play();
        }
      },
      child: Container(
        color: Colors.black,
        child: _failed
            ? const Center(
                child: Icon(
                  Icons.error_outline,
                  color: Colors.white54,
                  size: 32,
                ),
              )
            : !ready
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.showControls ? _togglePlay : _toggleMute,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FittedBox(
                      fit: widget.fit,
                      clipBehavior: Clip.hardEdge,
                      child: SizedBox(
                        width: c.value.size.width,
                        height: c.value.size.height,
                        child: VideoPlayer(c),
                      ),
                    ),
                    if (widget.showControls && !c.value.isPlaying)
                      const Center(
                        child: Icon(
                          Icons.play_circle_fill_rounded,
                          color: Colors.white70,
                          size: 64,
                        ),
                      ),
                    if (widget.showControls)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: VideoProgressIndicator(
                          c,
                          allowScrubbing: true,
                          padding: const EdgeInsets.only(top: 8),
                        ),
                      )
                    else
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _muted
                                ? Icons.volume_off_rounded
                                : Icons.volume_up_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Local-first image: cached file if present, otherwise the network URL.
class CachedMediaImage extends StatelessWidget {
  final MediaItem item;
  final BoxFit fit;

  const CachedMediaImage({super.key, required this.item, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    final File? local = context.select<AppContentProvider, File?>(
      (p) => p.fileFor(item),
    );
    if (local != null) {
      return Image.file(
        local,
        fit: fit,
        errorBuilder: (_, _, _) => _network(),
      );
    }
    return _network();
  }

  Widget _network() => Image.network(
    item.url,
    fit: fit,
    errorBuilder: (_, _, _) =>
        const ColoredBox(color: Colors.black12, child: Icon(Icons.image_not_supported)),
  );
}
