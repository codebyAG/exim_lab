import 'package:exim_lab/common/widgets/language_switch.dart';
import 'package:exim_lab/common/widgets/promo_banner_dialog.dart';
import 'package:exim_lab/common/widgets/theme_switch_button.dart';
import 'package:exim_lab/features/certificates/presentation/screens/certificates_screen.dart';
import 'package:exim_lab/features/chatai/presentation/screens/ai_chat_screen.dart';
import 'package:exim_lab/features/cto_banners/presentations/screens/random_cto_banner.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/animated_search_bar.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/continue_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/course_of_the_day.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/cta_carasoul.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/horizontal_courses.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/live_seminar_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/quick_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/section_header.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/tool_section.dart';
import 'package:exim_lab/features/freevideos/presentation/widgets/free_video_section.dart';
import 'package:exim_lab/features/news/presentation/screens/news_list_screen.dart';
import 'package:exim_lab/features/resources/presentation/screens/resource_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_list_screen.dart';
import 'package:sizer/sizer.dart';

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
          padding: EdgeInsets.only(bottom: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        const Row(
                          children: [
                            // ThemeSwitchButton(),
                            // SizedBox(width: 8),
                            LanguageSwitch(),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    Text(
                      t.translate('welcome_back'),
                      style: TextStyle(color: cs.onPrimary.withOpacity(0.75)),
                    ),

                    SizedBox(height: 0.5.h),

                    Text(
                      t.translate('dashboard_title'),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: cs.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 0.5.h),

                    Text(
                      t.translate('dashboard_subtitle'),
                      style: TextStyle(color: cs.onPrimary.withOpacity(0.75)),
                    ),

                    SizedBox(height: 2.h),

                    const CtaCarousel(),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // ================= SEARCH =================
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: AnimatedSearchBar(
                  hints: [
                    t.translate('search_hint'),
                    'Search IEC, GST, HS Code',
                    'Find import–export courses',
                    'Read trade policy updates',
                    'Check required documents',
                  ],
                  onTap: () {},
                ),
              ),

              SizedBox(height: 2.h),

              // ================= QUICK ACTIONS =================
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  children: [
                    Expanded(
                      child: QuickCard(
                        icon: Icons.video_library_outlined,
                        title: t.translate('my_courses'),
                        subtitle: t.translate('completed_status'),
                        onTap: () {
                          AppNavigator.push(context, const CoursesListScreen());
                        },
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: QuickCard(
                        icon: Icons.folder_open,
                        title: t.translate('resources'),
                        subtitle: t.translate('guides_docs'),
                        onTap: () {
                          AppNavigator.push(context, const ResourcesScreen());
                        },
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: QuickCard(
                        icon: Icons.workspace_premium,
                        title: t.translate('certificates'),
                        subtitle: t.translate('track_progress'),
                        onTap: () {
                          AppNavigator.push(
                            context,
                            const CertificatesScreen(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              LiveSeminarCard(
                title: 'Export Compliance & Documentation',
                subtitle: 'Live with Trade Expert',
                dateTime: '20 Jan • 6:00 PM',
                onTap: () {},
              ),

              SizedBox(height: 3.h),
              SectionHeader(
                title: 'Free Videos',
                subtitle: 'Watch & learn instantly',
              ),

              SizedBox(height: 1.5.h),

              const FreeVideosSection(),

              const SectionHeader(
                title: 'Tools',
                subtitle: 'Everything you need in one place',
              ),

              SizedBox(height: 1.5.h),

              const ToolsSection(),

              SizedBox(height: 3.h),

              SectionHeader(
                title: t.translate('continue_watching'),
                subtitle: t.translate('continue_subtitle'),
              ),

              ContinueCard(),
              const RandomCtoBanner(), // 🔥 HERE

              SectionHeader(
                title: t.translate('most_popular'),
                subtitle: t.translate('most_popular_subtitle'),
              ),

              const HorizontalCourses(),

              SizedBox(height: 3.h),

              CourseOfTheDayCard(
                title: 'Import Export Basics',
                subtitle: 'Learn trade from scratch',
                priceText: '₹999',
                badgeText: 'Limited time',
                imagePath: 'assets/coursegirl.png',
                onTap: () {},
              ),

              // ================= BECAUSE YOU WATCHED =================
              SectionHeader(
                title: t.translate('because_you_watched'),
                subtitle: t.translate('because_you_watched_subtitle'),
              ),

              HorizontalCourses(),

              SizedBox(height: 3.h),
              const RandomCtoBanner(), // 🔥 HERE

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

              const HorizontalCourses(),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: cs.surface,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurface.withOpacity(0.5),
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) {
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
