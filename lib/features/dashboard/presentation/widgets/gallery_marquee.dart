import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:exim_lab/core/constants/gallery_constants.dart';
import 'package:exim_lab/features/gallery/presentation/screens/gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GalleryMarquee extends StatefulWidget {
  const GalleryMarquee({super.key});

  @override
  State<GalleryMarquee> createState() => _GalleryMarqueeState();
}

class _GalleryMarqueeState extends State<GalleryMarquee> {
  late ScrollController _scrollController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_scrollController.hasClients) {
        double currentScroll = _scrollController.offset;
        _scrollController.jumpTo(currentScroll + 1.0);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urls = GalleryConstants.galleryUrls;
    if (urls.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Success Stories",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GalleryScreen()),
                  );
                },
                child: Text(
                  "See All →",
                  style: TextStyle(
                    color: const Color(0xFFFFD000),
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 18.h,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            // Infinite loop using modulo
            itemBuilder: (context, index) {
              final url = urls[index % urls.length];
              return _buildGalleryCard(context, url);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryCard(BuildContext context, String url) {
    return Container(
      width: 40.w,
      margin: EdgeInsets.only(right: 3.w, bottom: 1.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.white.withValues(alpha: 0.05),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
