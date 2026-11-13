import 'package:cached_network_image/cached_network_image.dart';
import 'package:exim_lab/features/app_content/data/models/app_content_models.dart';
import 'package:exim_lab/features/app_content/presentation/providers/app_content_provider.dart';
import 'package:exim_lab/features/app_content/presentation/widgets/cached_video_view.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

/// Header video under the home header. Renders nothing when `hero` is null.
class HeroMediaSection extends StatelessWidget {
  const HeroMediaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final hero = context.select<AppContentProvider, MediaItem?>((p) => p.hero);
    if (hero == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          // Respect the server's ratio — don't hardcode 16:9.
          aspectRatio: hero.aspectRatio(),
          child: hero.isVideo
              ? CachedVideoView(item: hero)
              : CachedMediaImage(item: hero),
        ),
      ),
    );
  }
}

/// Vertical testimonial videos. Whole section is hidden when the list is
/// empty. Videos download lazily: a card only requests its file once it is
/// actually built by the horizontal list (i.e. near the viewport).
class TestimonialVideosSection extends StatelessWidget {
  const TestimonialVideosSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.select<AppContentProvider, List<MediaItem>>(
      (p) => p.testimonials,
    );
    if (items.isEmpty) return const SizedBox.shrink();

    final height = 32.h;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        const SectionHeader(
          title: 'Student Testimonials',
          subtitle: 'Hear it from our members',
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: height,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, _) => SizedBox(width: 3.w),
            itemBuilder: (context, i) {
              final item = items[i];
              return _TestimonialCard(
                key: ValueKey('${item.id}-${item.checksum}'),
                item: item,
                height: height,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TestimonialCard extends StatefulWidget {
  final MediaItem item;
  final double height;

  const _TestimonialCard({super.key, required this.item, required this.height});

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard> {
  @override
  void initState() {
    super.initState();
    // Lazy: only built cards fetch their video.
    context.read<AppContentProvider>().ensure(widget.item);
  }

  void _open() {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: widget.item.aspectRatio(fallback: 9 / 16),
              child: CachedVideoView(
                item: widget.item,
                loop: false,
                muted: false,
                showControls: true,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final width = widget.height * item.aspectRatio(fallback: 9 / 16);

    return GestureDetector(
      onTap: _open,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          width: width,
          height: widget.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (item.thumbnailUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: item.thumbnailUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => const _CardBackdrop(),
                )
              else
                const _CardBackdrop(),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                    stops: [0.5, 1],
                  ),
                ),
              ),
              const Center(
                child: Icon(
                  Icons.play_circle_fill_rounded,
                  color: Colors.white,
                  size: 52,
                ),
              ),
              if (item.title.isNotEmpty)
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
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

class _CardBackdrop extends StatelessWidget {
  const _CardBackdrop();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0A2066), Color(0xFF020C28)],
      ),
    ),
  );
}
