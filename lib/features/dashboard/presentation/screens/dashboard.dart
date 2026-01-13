import 'package:exim_lab/common/widgets/language_switch.dart';
import 'package:exim_lab/common/widgets/promo_banner_dialog.dart';
import 'package:exim_lab/common/widgets/theme_switch_button.dart';
import 'package:exim_lab/features/certificates/presentation/screens/certificates_screen.dart';
import 'package:exim_lab/features/chatai/presentation/screens/ai_chat_screen.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/animated_search_bar.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/continue_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/course_of_the_day.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/cta_carasoul.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/horizontal_courses.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/quick_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/section_header.dart';
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

                    CtaCarousel(),
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
                    QuickCard(
                      icon: Icons.video_library_outlined,
                      title: t.translate('my_courses'),
                      subtitle: t.translate('completed_status'),
                      onTap: () {
                        AppNavigator.push(context, const CoursesListScreen());
                      },
                    ),
                    const SizedBox(width: 12),
                    QuickCard(
                      icon: Icons.folder_open,
                      title: t.translate('resources'),
                      subtitle: t.translate('guides_docs'),
                      onTap: () {
                        AppNavigator.push(context, const ResourcesScreen());
                      },
                    ),
                    const SizedBox(width: 12),
                    QuickCard(
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
              SectionHeader(
                title: t.translate('continue_watching'),
                subtitle: t.translate('continue_subtitle'),
              ),

              ContinueCard(),

              const SizedBox(height: 24),

              // ================= MOST POPULAR =================
              SectionHeader(
                title: t.translate('most_popular'),
                subtitle: t.translate('most_popular_subtitle'),
              ),

              HorizontalCourses(),

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
              SectionHeader(
                title: t.translate('because_you_watched'),
                subtitle: t.translate('because_you_watched_subtitle'),
              ),

              HorizontalCourses(),

              const SizedBox(height: 24),

              // ================= RECOMMENDED =================
              SectionHeader(
                title: t.translate('recommended_for_you'),
                subtitle: t.translate('based_on_interest'),
                trailing: TextButton(
                  onPressed: () {
                    AppNavigator.push(context, const CoursesListScreen());
                  },
                  child: Text(t.translate('view_all')),
                ),
              ),

              HorizontalCourses(),
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
