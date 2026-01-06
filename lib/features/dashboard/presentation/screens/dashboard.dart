import 'package:exim_lab/common/widgets/language_switch.dart';
import 'package:exim_lab/common/widgets/theme_switch_button.dart';
import 'package:exim_lab/features/certificates/presentation/screens/certificates_screen.dart';
import 'package:exim_lab/features/chatai/presentation/screens/ai_chat_screen.dart';
import 'package:exim_lab/features/resources/presentation/screens/resource_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
                padding: const EdgeInsets.all(20),
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

                    // CTA CARD
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(22),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.translate('cta_title'),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  t.translate('cta_subtitle'),
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              AppNavigator.push(
                                context,
                                const CoursesListScreen(),
                              );
                            },
                            child: Text(t.translate('start_learning')),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= SEARCH =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: appCardShadow(context),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: cs.onSurface.withOpacity(0.5)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          t.translate('search_hint'),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                      Icon(Icons.tune, color: cs.onSurface.withOpacity(0.4)),
                    ],
                  ),
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
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            AppNavigator.push(context, const CoursesListScreen());
          } else if (index == 2) {
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
      padding: const EdgeInsets.symmetric(horizontal: 20,),
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
    final cs = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: appCardShadow(context),
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: cs.primary),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurface.withOpacity(0.6),
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
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.play_circle_fill, color: cs.primary, size: 36),
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
        children: const [
          _CourseCard(
            title: 'Advanced Export Strategy',
            rating: '4.8',
            learners: '2.1k',
          ),
          SizedBox(width: 14),
          _CourseCard(
            title: 'Import Documentation Mastery',
            rating: '4.8',
            learners: '1.9k',
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

  const _CourseCard({
    required this.title,
    required this.rating,
    required this.learners,
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
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Icon(Icons.play_circle_outline, size: 40),
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
