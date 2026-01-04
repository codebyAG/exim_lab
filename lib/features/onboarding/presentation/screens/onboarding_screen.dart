import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/dashboard/presentation/screens/dashboard.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<_OnboardData> _pages = [
    _OnboardData(
      titleKey: 'onboard_title_1',
      subtitleKey: 'onboard_subtitle_1',
      icon: Icons.public_outlined,
    ),
    _OnboardData(
      titleKey: 'onboard_title_2',
      subtitleKey: 'onboard_subtitle_2',
      icon: Icons.assignment_outlined,
    ),
    _OnboardData(
      titleKey: 'onboard_title_3',
      subtitleKey: 'onboard_subtitle_3',
      icon: Icons.trending_up_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 SKIP BUTTON
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: Text(t.translate('skip')),
              ),
            ),

            // 🔹 PAGE VIEW
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (_, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 🔹 ICON
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF8A00).withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page.icon,
                            size: 60,
                            color: const Color(0xFFFF8A00),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // 🔹 TITLE
                        Text(
                          t.translate(page.titleKey),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 28,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 🔹 SUBTITLE
                        Text(
                          t.translate(page.subtitleKey),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 17,
                            height: 1.4,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // 🔹 WHO IS THIS FOR (VALUE ADD)
                        Text(
                          t.translate('onboard_who_for'),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.black.withOpacity(0.55),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 🔹 INDICATOR + BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  // 🔹 PAGE INDICATOR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        height: 8,
                        width: _currentIndex == index ? 22 : 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? const Color(0xFFFF8A00)
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 PROGRESS TEXT
                  Text(
                    t.translate(
                      'step_of',
                      args: {
                        'current': (_currentIndex + 1).toString(),
                        'total': _pages.length.toString(),
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 FULL WIDTH CTA BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8A00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentIndex == _pages.length - 1
                            ? t.translate('get_started')
                            : t.translate('continue'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextPage() {
    if (_currentIndex == _pages.length - 1) {
      _finishOnboarding();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  void _finishOnboarding() {
    // TODO: Navigate to Dashboard
    AppNavigator.push(context, DashboardScreen());
  }
}

// 🔹 DATA MODEL
class _OnboardData {
  final String titleKey;
  final String subtitleKey;
  final IconData icon;

  const _OnboardData({
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
  });
}
