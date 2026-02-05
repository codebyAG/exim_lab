import 'package:exim_lab/common/widgets/language_switch.dart';
import 'package:exim_lab/common/widgets/promo_banner_dialog.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/certificates/presentation/screens/certificates_screen.dart';
import 'package:exim_lab/features/chatai/presentation/screens/ai_chat_screen.dart';
import 'package:exim_lab/features/courses/data/models/course_model.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_details_screen.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_list_screen.dart';
import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';
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
import 'package:exim_lab/features/freevideos/data/models/free_videos_model.dart';
import 'package:exim_lab/features/freevideos/presentation/widgets/free_video_section.dart';
import 'package:exim_lab/features/news/presentation/screens/news_list_screen.dart';
import 'package:exim_lab/features/quiz/presentation/screens/quiz_topics_screen.dart';
import 'package:exim_lab/features/resources/presentation/screens/resource_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:exim_lab/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        await context.read<DashboardProvider>().fetchDashboardData();

        // Show Promo Banner if available
        if (mounted) {
          final data = context.read<DashboardProvider>().data;
          if (data?.addons.popup != null) {
            _showPromoBanner(data!.addons.popup!);
          }
        }
      }
    });
  }

  void _showPromoBanner(BannerModel popup) {
    String imgUrl = popup.imageUrl.trim();
    if (imgUrl.isNotEmpty &&
        (imgUrl.startsWith("'") || imgUrl.startsWith('"'))) {
      imgUrl = imgUrl.substring(1, imgUrl.length - 1);
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => PromoBannerDialog(
        imageUrl: imgUrl,
        link: popup.ctaUrl, // mapped from 'link' in json
      ),
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
        child: RefreshIndicator(
          onRefresh: () =>
              context.read<DashboardProvider>().fetchDashboardData(),
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            children: [
              // 1. HEADER (Static)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.translate('welcome_back'),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurface.withOpacity(0.6),
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Akash Goyal', // TODO: Dynamic User Name
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        AppNavigator.push(context, const ProfileScreen());
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: cs.primaryContainer,
                        child: Icon(Icons.person, color: cs.primary),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),

              // 2. SEARCH BAR (Static)
              AnimatedSearchBar(
                hints: [
                  t.translate('search_hint'),
                  'Search IEC, GST, HS Code',
                  'Find import–export courses',
                ],
                onTap: () {},
              ),
              SizedBox(height: 2.h),

              // DYNAMIC CONTENT
              Consumer<DashboardProvider>(
                builder: (context, dashboard, child) {
                  if (dashboard.isLoading) {
                    return SizedBox(
                      height: 50.h,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (dashboard.error != null) {
                    return Center(child: Text('Error: ${dashboard.error}'));
                  }

                  final data = dashboard.data;
                  if (data == null) return const SizedBox();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 3. CAROUSEL (From Addons)
                      if (data.addons.carousel.isNotEmpty) ...[
                        CtaCarousel(banners: data.addons.carousel),
                        SizedBox(height: 3.h),
                      ],

                      // 4. QUICK ACTIONS (Static)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: QuickCard(
                                icon: Icons.video_library_rounded,
                                title: t.translate('my_courses'),
                                subtitle: t.translate('completed_status'),
                                onTap: () => AppNavigator.push(
                                  context,
                                  const CoursesListScreen(),
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: QuickCard(
                                icon: Icons.folder_copy_rounded,
                                title: t.translate('resources'),
                                subtitle: t.translate('guides_docs'),
                                onTap: () => AppNavigator.push(
                                  context,
                                  const ResourcesScreen(),
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: QuickCard(
                                icon: Icons.workspace_premium_rounded,
                                title: t.translate('certificates'),
                                subtitle: t.translate('track_progress'),
                                onTap: () => AppNavigator.push(
                                  context,
                                  const CertificatesScreen(),
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: QuickCard(
                                icon: Icons.quiz_rounded,
                                title: 'Quizzes',
                                subtitle: 'Test skills',
                                onTap: () => AppNavigator.push(
                                  context,
                                  const QuizTopicsScreen(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // 5. LIVE SEMINAR (If present)
                      if (data.liveSeminar != null) ...[
                        LiveSeminarCard(
                          title: data.liveSeminar!.title,
                          subtitle: data.liveSeminar!.subtitle,
                          dateTime: data.liveSeminar!.dateTime,
                          onTap: () {},
                        ),
                        SizedBox(height: 4.h),
                      ],

                      // 6. DYNAMIC SECTIONS LOOP
                      ...data.sections.map((section) {
                        // CONTINUE WATCHING
                        if (section.key == 'continue') {
                          final courses = section.data.cast<CourseModel>();
                          if (courses.isEmpty) return const SizedBox();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionHeader(
                                title: section.title,
                                subtitle: section.subtitle,
                              ),
                              SizedBox(height: 1.5.h),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Row(
                                  children: courses
                                      .map(
                                        (course) => ContinueCard(
                                          course: course,
                                          onTap: () {
                                            AppNavigator.push(
                                              context,
                                              CourseDetailsScreen(
                                                courseId: course.id,
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              SizedBox(height: 2.h),
                            ],
                          );
                        }

                        // COURSES
                        if (section.key == 'course' ||
                            section.key.contains('Popular') ||
                            section.key.contains('Recommended')) {
                          final courses = section.data.cast<CourseModel>();
                          if (courses.isEmpty) return const SizedBox();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionHeader(
                                title: section.title,
                                subtitle: section.subtitle,
                              ),
                              SizedBox(height: 1.5.h),
                              HorizontalCourses(courses: courses),
                              SizedBox(height: 2.h),
                            ],
                          );
                        }
                        // FREE VIDEOS
                        else if (section.key == 'freeVideos') {
                          final videos = section.data.cast<FreeVideoModel>();
                          if (videos.isEmpty) return const SizedBox();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionHeader(
                                title: section.title,
                                subtitle: section.subtitle,
                              ),
                              SizedBox(height: 1.5.h),
                              FreeVideosSection(videos: videos),
                              SizedBox(height: 2.h),
                            ],
                          );
                        }
                        // BANNERS
                        else if (section.key == 'banner') {
                          final banners = section.data.cast<BannerModel>();
                          if (banners.isEmpty) return const SizedBox();

                          return Column(
                            children: [
                              InlineBanner(banners: banners),
                              SizedBox(height: 2.h),
                            ],
                          );
                        }
                        return const SizedBox();
                      }).toList(),

                      // 7. COURSE OF THE DAY
                      if (data.courseOfTheDay != null) ...[
                        CourseOfTheDayCard(
                          title: data.courseOfTheDay!.title,
                          subtitle: data.courseOfTheDay!.subtitle,
                          priceText: data.courseOfTheDay!.priceText,
                          badgeText: data.courseOfTheDay!.badgeText,
                          imagePath: data.courseOfTheDay!.imageUrl,
                          onTap: () {},
                        ),
                        SizedBox(height: 2.h),
                      ],

                      // 8. TOOLS
                      const SectionHeader(
                        title: 'Tools',
                        subtitle: 'Everything you need in one place',
                      ),
                      SizedBox(height: 1.5.h),
                      const ToolsSection(),
                      SizedBox(height: 4.h),
                    ],
                  );
                },
              ),
            ],
          ),
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
