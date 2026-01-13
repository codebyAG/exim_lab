import 'package:exim_lab/common/widgets/language_switch.dart';
import 'package:exim_lab/common/widgets/promo_banner_dialog.dart';
import 'package:exim_lab/common/widgets/theme_switch_button.dart';
import 'package:exim_lab/features/certificates/presentation/screens/certificates_screen.dart';
import 'package:exim_lab/features/chatai/presentation/screens/ai_chat_screen.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/animated_search_bar.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/course_of_the_day.dart';
import 'package:exim_lab/features/news/presentation/screens/news_list_screen.dart';
import 'package:exim_lab/features/resources/presentation/screens/resource_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2));
      _showPromoBanner();
    });
  }

  void _showPromoBanner() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const PromoBannerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,

      // 🔹 AI CHAT FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: cs.primary,
        tooltip: t.translate('ai_support'),
        onPressed: () {
          AppNavigator.push(context, const AiChatScreen());
        },
        child: Icon(Icons.support_agent, color: cs.onPrimary),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TOP ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.translate('app_name'),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: cs.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: const [
                            ThemeSwitchButton(),
                            SizedBox(width: 8),
                            LanguageSwitch(),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      t.translate('welcome_back'),
                      style: TextStyle(color: cs.onPrimary.withOpacity(0.75)),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      t.translate('dashboard_title'),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: cs.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      t.translate('dashboard_subtitle'),
                      style: TextStyle(color: cs.onPrimary.withOpacity(0.75)),
                    ),

                    const SizedBox(height: 20),

                    _CtaCarousel(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= SEARCH =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedSearchBar(
                  hints: [
                    t.translate('search_hint'),
                    'Search IEC, GST, HS Code',
                    'Find import–export courses',
                    'Read trade policy updates',
                    'Check required documents',
                  ],
                  onTap: () {
                    // TODO: Navigate to search screen later
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ================= QUICK ACTIONS =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _QuickCard(
                      icon: Icons.video_library_outlined,
                      title: t.translate('my_courses'),
                      subtitle: t.translate('completed_status'),
                      onTap: () {
                        AppNavigator.push(context, const CoursesListScreen());
                      },
                    ),
                    const SizedBox(width: 12),
                    _QuickCard(
                      icon: Icons.folder_open,
                      title: t.translate('resources'),
                      subtitle: t.translate('guides_docs'),
                      onTap: () {
                        AppNavigator.push(context, const ResourcesScreen());
                      },
                    ),
                    const SizedBox(width: 12),
                    _QuickCard(
                      icon: Icons.workspace_premium,
                      title: t.translate('certificates'),
                      subtitle: t.translate('track_progress'),
                      onTap: () {
                        AppNavigator.push(context, const CertificatesScreen());
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ================= CONTINUE WATCHING =================
              _SectionHeader(
                title: t.translate('continue_watching'),
                subtitle: t.translate('continue_subtitle'),
              ),

              _ContinueCard(),

              const SizedBox(height: 24),

              // ================= MOST POPULAR =================
              _SectionHeader(
                title: t.translate('most_popular'),
                subtitle: t.translate('most_popular_subtitle'),
              ),

              _HorizontalCourses(),

              const SizedBox(height: 24),
              CourseOfTheDayCard(
                title: 'Import Export Basics',
                subtitle: 'Learn trade from scratch',
                priceText: '₹999',
                badgeText: 'Limited time',
                imagePath: 'assets/coursegirl.png',
                onTap: () {
                  // navigate to course details
                },
              ),

              // ================= BECAUSE YOU WATCHED =================
              _SectionHeader(
                title: t.translate('because_you_watched'),
                subtitle: t.translate('because_you_watched_subtitle'),
              ),

              _HorizontalCourses(),

              const SizedBox(height: 24),

              // ================= RECOMMENDED =================
              _SectionHeader(
                title: t.translate('recommended_for_you'),
                subtitle: t.translate('based_on_interest'),
                trailing: TextButton(
                  onPressed: () {
                    AppNavigator.push(context, const CoursesListScreen());
                  },
                  child: Text(t.translate('view_all')),
                ),
              ),

              _HorizontalCourses(),
            ],
          ),
        ),
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: cs.surface,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurface.withOpacity(0.5),
        currentIndex: 0, // Home/Dashboard
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          if (index == 0) {
            // Home → already here
            return;
          } else if (index == 1) {
            AppNavigator.push(context, const CoursesListScreen());
          } else if (index == 2) {
            AppNavigator.push(context, const NewsListScreen());
          } else if (index == 3) {
            AppNavigator.push(context, const ResourcesScreen());
          }
        },

        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: t.translate('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.play_circle_outline),
            label: t.translate('courses'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.newspaper_outlined),
            label: t.translate('news'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.folder_open),
            label: t.translate('resources'),
          ),
        ],
      ),
    );
  }
}

// ================= REUSABLE WIDGETS =================

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(subtitle, style: theme.textTheme.bodySmall),
            ],
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 130,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: appCardShadow(context),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 🔹 TOP CURVED HALF
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.90),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
              ),

              // 🔹 ICON ON CURVE LINE
              Positioned(
                top: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: cs.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: cs.primary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(icon, size: 22, color: cs.primary),
                  ),
                ),
              ),

              // 🔹 CONTENT
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 72, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<BoxShadow> appCardShadow(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return [
    BoxShadow(
      color: isDark
          ? Colors.black.withOpacity(0.4)
          : Colors.black.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}

class _ContinueCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: appCardShadow(context),
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: const DecorationImage(
                  image: AssetImage('assets/course1.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Export Basics – Lesson 3',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: 0.65,
                    backgroundColor: cs.surfaceContainerHighest,
                    color: cs.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalCourses extends StatelessWidget {
  const _HorizontalCourses();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const _CourseCard(
            title: 'Advanced Export Strategy',
            rating: '4.8',
            learners: '2.1k',
            image: 'assets/course1.png',
          ),
          const SizedBox(width: 14),
          const _CourseCard(
            title: 'Import Documentation Mastery',
            rating: '4.8',
            learners: '1.9k',
            image: 'assets/course2.png',
          ),
          const SizedBox(width: 14),
          const _CourseCard(
            title: 'Export Business Basics',
            rating: '4.7',
            learners: '1.4k',
            image: 'assets/course3.jpg',
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final String title;
  final String rating;
  final String learners;
  final String image;

  const _CourseCard({
    required this.title,
    required this.rating,
    required this.learners,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: appCardShadow(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(
              '$rating • $learners',
              style: TextStyle(
                fontSize: 12,
                color: cs.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CtaCarousel extends StatefulWidget {
  const _CtaCarousel();

  @override
  State<_CtaCarousel> createState() => _CtaCarouselState();
}

class _CtaCarouselState extends State<_CtaCarousel> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<_CtaData> _ctas = [
    _CtaData(
      title: 'Start Your Export Journey',
      subtitle: 'Learn trade basics step-by-step',
      buttonText: 'Start Learning',
    ),
    _CtaData(
      title: 'New Trade Policies',
      subtitle: 'Stay updated with law changes',
      buttonText: 'Read News',
    ),
    _CtaData(
      title: 'Free Export Guides',
      subtitle: 'Documents & checklists',
      buttonText: 'View Resources',
    ),
    _CtaData(
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

        _DotsIndicator(count: _ctas.length, currentIndex: _currentIndex),
      ],
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _DotsIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final bool isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 7,
          width: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? Colors
                      .white // ✅ ACTIVE ALWAYS WHITE
                : isDark
                ? Colors.white.withOpacity(0.35)
                : Colors.black.withOpacity(0.3),
          ),
        );
      }),
    );
  }
}

class _CtaData {
  final String title;
  final String subtitle;
  final String buttonText;

  const _CtaData({
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });
}
