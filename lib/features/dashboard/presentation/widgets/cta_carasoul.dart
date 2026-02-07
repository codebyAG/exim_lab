import 'package:exim_lab/core/constants/appcardshadow.dart';
import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/dots_iniidcator.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CtaCarousel extends StatefulWidget {
  final List<BannerModel> banners;
  const CtaCarousel({super.key, required this.banners});

  @override
  State<CtaCarousel> createState() => CtaCarouselState();
}

class CtaCarouselState extends State<CtaCarousel> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.banners.isNotEmpty) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));
      if (!mounted) return;
      if (widget.banners.isEmpty) return;

      _currentIndex = (_currentIndex + 1) % widget.banners.length;
      if (_controller.hasClients) {
        _controller.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        SizedBox(
          height: 18.h, // ✅ responsive height
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final banner = widget.banners[index];

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                child: Container(
                  padding: EdgeInsets.all(2.h),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: appCardShadow(context),
                    image: DecorationImage(
                      image: NetworkImage(banner.imageUrl),
                      fit: BoxFit.cover,
                      // opacity: 0.4, // Adjust opacity if needed or based on design
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (banner.ctaUrl.isNotEmpty) {
                        launchUrlString(banner.ctaUrl);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: const SizedBox.expand(),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 1.2.h),

        DotsIndicator(
          count: widget.banners.length,
          currentIndex: _currentIndex,
        ),
      ],
    );
  }
}
