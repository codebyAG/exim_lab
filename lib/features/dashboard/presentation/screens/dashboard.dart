import 'package:exim_lab/common/widgets/language_switch.dart';
import 'package:exim_lab/common/widgets/promo_banner_dialog.dart';
import 'package:exim_lab/features/certificates/presentation/screens/certificates_screen.dart';
import 'package:exim_lab/features/chatai/presentation/screens/ai_chat_screen.dart';
import 'package:exim_lab/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/animated_search_bar.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/continue_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/course_of_the_day.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/cta_carasoul.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/horizontal_courses.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/inline_banner.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/live_seminar_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/quick_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/section_header.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/tool_section.dart';
import 'package:exim_lab/features/freevideos/presentation/widgets/free_video_section.dart';
import 'package:exim_lab/features/news/presentation/screens/news_list_screen.dart';
import 'package:exim_lab/features/resources/presentation/screens/resource_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_list_screen.dart';
import 'package:exim_lab/features/quiz/presentation/screens/quiz_topics_screen.dart';
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

      // Fetch Dashboard Data
      if (mounted) {
        context.read<DashboardProvider>().fetchDashboardData();
      }

      // Show Promo Banner
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

      // Floating AI Support Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: cs.primary,
        tooltip: t.translate('ai_support'),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          AppNavigator.push(context, const AiChatScreen());
        },
        child: Icon(Icons.support_agent, color: cs.onPrimary, size: 28),
      ),

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ================= HEADER =================
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(3.w, 2.h, 3.w, 1.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.translate('welcome_back'),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                t.translate(
                                  'dashboard_title',
                                ), // Assuming this is User Name or Title
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: cs.onSurface,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Utility Buttons
                        const Row(children: [LanguageSwitch()]),
                      ],
                    ),
                    SizedBox(height: 3.h),

                    // Search Bar
                    AnimatedSearchBar(
                      hints: [
                        t.translate('search_hint'),
                        'Search IEC, GST, HS Code',
                        'Find import–export courses',
                        'Read trade policy updates',
                        'Check required documents',
                      ],
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            // ================= CONTENT BODY =================
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Consumer<DashboardProvider>(
                    builder: (context, dashboard, child) {
                      if (dashboard.isLoading) {
                        return SizedBox(
                          height: 50.h,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (dashboard.error != null) {
                        return Center(
                          child: Text(
                            'Failed to load dashboard: ${dashboard.error}',
                          ),
                        );
                      }

                      final data = dashboard.data;
                      if (data == null) return const SizedBox();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // CTA Carousel
                          CtaCarousel(banners: data.banners.carousel),
                          SizedBox(height: 3.h),

                          // Quick Actions (Static)
                          Row(
                            children: [
                              Expanded(
                                child: QuickCard(
                                  icon: Icons.video_library_rounded,
                                  title: t.translate('my_courses'),
                                  subtitle: t.translate('completed_status'),
                                  onTap: () {
                                    AppNavigator.push(
                                      context,
                                      const CoursesListScreen(),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: QuickCard(
                                  icon: Icons.folder_copy_rounded,
                                  title: t.translate('resources'),
                                  subtitle: t.translate('guides_docs'),
                                  onTap: () {
                                    AppNavigator.push(
                                      context,
                                      const ResourcesScreen(),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: QuickCard(
                                  icon: Icons.workspace_premium_rounded,
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
                              SizedBox(width: 3.w),
                              Expanded(
                                child: QuickCard(
                                  icon: Icons.quiz_rounded,
                                  title: 'Quizzes',
                                  subtitle: 'Test skills',
                                  onTap: () {
                                    AppNavigator.push(
                                      context,
                                      const QuizTopicsScreen(),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 4.h),

                          // Live Seminar (Dynamic)
                          if (data.liveSeminar != null)
                            LiveSeminarCard(
                              title: data.liveSeminar!.title,
                              subtitle: data.liveSeminar!.subtitle,
                              dateTime: data.liveSeminar!.dateTime,
                              onTap: () {
                                if (data.liveSeminar!.meetingUrl.isNotEmpty) {
                                  // UrlLauncher logic here if needed
                                }
                              },
                            ),

                          if (data.liveSeminar != null) SizedBox(height: 4.h),

                          // Free Videos
                          if (data.freeVideos.isNotEmpty) ...[
                            SectionHeader(
                              title: 'Free Videos',
                              subtitle: 'Watch & learn instantly',
                            ),
                            SizedBox(height: 1.5.h),
                            FreeVideosSection(videos: data.freeVideos),
                            SizedBox(height: 2.h),
                          ],

                          // Tools (Static)
                          const SectionHeader(
                            title: 'Tools',
                            subtitle: 'Everything you need in one place',
                          ),
                          SizedBox(height: 1.5.h),
                          const ToolsSection(),

                          SizedBox(height: 4.h),

                          // Continue Watching
                          if (data.continueCourses.isNotEmpty) ...[
                            SectionHeader(
                              title: t.translate('continue_watching'),
                              subtitle: t.translate('continue_subtitle'),
                            ),
                            SizedBox(height: 1.5.h),
                            ContinueCard(),
                            SizedBox(height: 2.h),
                          ],

                          // Inline Banner 1
                          InlineBanner(banners: data.banners.inline),
                          SizedBox(height: 2.h),

                          // Most Popular
                          if (data.mostPopularCourses.isNotEmpty) ...[
                            SectionHeader(
                              title: t.translate('most_popular'),
                              subtitle: t.translate('most_popular_subtitle'),
                            ),
                            SizedBox(height: 1.5.h),
                            HorizontalCourses(courses: data.mostPopularCourses),
                            SizedBox(height: 2.h),
                          ],

                          // Course of the Day (Dynamic)
                          if (data.courseOfTheDay != null) ...[
                            CourseOfTheDayCard(
                              title: data.courseOfTheDay!.title,
                              subtitle: data.courseOfTheDay!.subtitle,
                              priceText: data.courseOfTheDay!.priceText,
                              badgeText: data.courseOfTheDay!.badgeText,
                              imagePath:
                                  'assets/coursegirl.png', // Or use network image if URL provided
                              onTap: () {},
                            ),
                            SizedBox(height: 2.h),
                          ],

                          // Recommended
                          if (data.recommendedCourses.isNotEmpty) ...[
                            SectionHeader(
                              title: t.translate('recommended_for_you'),
                              subtitle: t.translate('based_on_interest'),
                              trailing: TextButton(
                                onPressed: () {
                                  AppNavigator.push(
                                    context,
                                    const CoursesListScreen(),
                                  );
                                },
                                child: Text(t.translate('view_all')),
                              ),
                            ),
                            HorizontalCourses(courses: data.recommendedCourses),
                          ],
                        ],
                      );
                    },
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: cs.surface,
          elevation: 0,
          selectedItemColor: cs.primary,
          unselectedItemColor: cs.onSurfaceVariant.withOpacity(0.6),
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13.sp,
          ),
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
              icon: const Icon(Icons.home_rounded),
              activeIcon: const Icon(Icons.home_filled),
              label: t.translate('home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.play_circle_outline_rounded),
              activeIcon: const Icon(Icons.play_circle_filled_rounded),
              label: t.translate('courses'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.newspaper_rounded),
              activeIcon: const Icon(Icons.newspaper),
              label: t.translate('news'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.folder_open_rounded),
              activeIcon: const Icon(Icons.folder_rounded),
              label: t.translate('resources'),
            ),
          ],
        ),
      ),
    );
  }
}
