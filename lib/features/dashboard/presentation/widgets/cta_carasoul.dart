import 'package:exim_lab/core/constants/appcardshadow.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/dots_iniidcator.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CtaCarousel extends StatefulWidget {
  const CtaCarousel({super.key});

  @override
  State<CtaCarousel> createState() => CtaCarouselState();
}

class CtaCarouselState extends State<CtaCarousel> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<CtaData> _ctas = const [
    CtaData(
      title: 'Start Your Export Journey',
      subtitle: 'Learn trade basics step-by-step',
      buttonText: 'Start Learning',
    ),
    CtaData(
      title: 'New Trade Policies',
      subtitle: 'Stay updated with law changes',
      buttonText: 'Read News',
    ),
    CtaData(
      title: 'Free Export Guides',
      subtitle: 'Documents & checklists',
      buttonText: 'View Resources',
    ),
    CtaData(
      title: 'Earn Certificates',
      subtitle: 'Complete courses & get certified',
      buttonText: 'View Certificates',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));
      if (!mounted) return;

      _currentIndex = (_currentIndex + 1) % _ctas.length;
      _controller.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        SizedBox(
          height: 18.h, // ✅ responsive height
          child: PageView.builder(
            controller: _controller,
            itemCount: _ctas.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final cta = _ctas[index];

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                child: Container(
                  padding: EdgeInsets.all(2.h),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: appCardShadow(context),
                    image: const DecorationImage(
                      image: AssetImage('assets/cta_card_bg.png'),
                      fit: BoxFit.cover,
                      opacity: 0.4, // Lowered opacity for subtle effect
                    ),
                  ),
                  child: Row(
                    children: [
                      // TEXT
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cta.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 0.8.h),
                            Text(
                              cta.subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 2.w),

                      // CTA BUTTON
                      SizedBox(
                        height: 4.6.h,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            cta.buttonText,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: cs.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 1.2.h),

        DotsIndicator(count: _ctas.length, currentIndex: _currentIndex),
      ],
    );
  }
}

class CtaData {
  final String title;
  final String subtitle;
  final String buttonText;

  const CtaData({
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });
}
