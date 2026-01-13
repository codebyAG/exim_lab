import 'package:exim_lab/core/constants/appcardshadow.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/dots_iniidcator.dart';
import 'package:flutter/material.dart';

class CtaCarousel extends StatefulWidget {
  const CtaCarousel();

  @override
  State<CtaCarousel> createState() => CtaCarouselState();
}

class CtaCarouselState extends State<CtaCarousel> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<CtaData> _ctas = [
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
          height: 150,
          child: PageView.builder(
            controller: _controller,
            itemCount: _ctas.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final cta = _ctas[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: appCardShadow(context),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              cta.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cta.subtitle,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(cta.buttonText),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

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
