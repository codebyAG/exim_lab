import 'package:cached_network_image/cached_network_image.dart';
import 'package:exim_lab/common/widgets/promo_banner_dialog.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:exim_lab/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:exim_lab/features/chatai/presentation/screens/ai_chat_screen.dart';
import 'package:exim_lab/features/courses/data/models/course_model.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_details_screen.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_list_screen.dart';
import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';
import 'package:exim_lab/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/continue_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/home_shorts_section.dart';
import 'package:exim_lab/features/shorts/presentation/screens/shorts_feed_screen.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/cta_carasoul.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/horizontal_courses.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/inline_banner.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/quick_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/section_header.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/tool_section.dart';
import 'package:exim_lab/features/freevideos/data/models/free_videos_model.dart';
import 'package:exim_lab/features/freevideos/presentation/widgets/free_video_section.dart';
import 'package:exim_lab/features/news/presentation/screens/news_list_screen.dart';
import 'package:exim_lab/features/quiz/presentation/screens/quiz_topics_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:exim_lab/features/profile/presentation/screens/profile_screen.dart';
import 'package:exim_lab/features/module_manager/presentation/widgets/module_visibility.dart';
import 'package:exim_lab/features/module_manager/presentation/providers/module_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/dashboard_shimmer.dart';

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
        context.read<AnalyticsService>().logEvent('home_view');
        await context.read<DashboardProvider>().fetchDashboardData();
        if (mounted) {
          await context.read<NotificationsProvider>().fetchUnreadCount();
        }

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
    final moduleProvider = Provider.of<ModuleProvider>(context);

    // Prepare Bottom Navigation Items dynamically
    List<BottomNavigationBarItem> navItems = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_rounded),
        activeIcon: const Icon(Icons.home_filled),
        label: t.translate('home'),
      ),
    ];

    // Parallel list of actions for each tab (index 0 is null/no-op)
    List<VoidCallback?> navActions = [null];

    if (moduleProvider.isEnabled('shortVideos')) {
      navItems.add(
        BottomNavigationBarItem(
          icon: const Icon(Icons.slow_motion_video_rounded),
          activeIcon: const Icon(Icons.slow_motion_video),
          label: t.translate('shorts'),
        ),
      );
      navActions.add(
        () => AppNavigator.push(context, const ShortsFeedScreen()),
      );
    }

    if (moduleProvider.isEnabled('courses')) {
      navItems.add(
        BottomNavigationBarItem(
          icon: const Icon(Icons.play_circle_outline_rounded),
          activeIcon: const Icon(Icons.play_circle_filled_rounded),
          label: t.translate('courses'),
        ),
      );
      navActions.add(() {
        AppNavigator.push(context, const CoursesListScreen());
      });
    }

    if (moduleProvider.isEnabled('news')) {
      navItems.add(
        BottomNavigationBarItem(
          icon: const Icon(Icons.newspaper_rounded),
          activeIcon: const Icon(Icons.newspaper),
          label: t.translate('news'),
        ),
      );
      navActions.add(() {
        AppNavigator.push(context, const NewsListScreen());
      });
    }

    // Always add Profile
    navItems.add(
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_outline_rounded),
        activeIcon: const Icon(Icons.person_rounded),
        label: t.translate('profile'),
      ),
    );
    navActions.add(() {
      AppNavigator.push(context, const ProfileScreen());
    });

    return Scaffold(
      backgroundColor: cs.surface,

      // Floating AI Support Button
      floatingActionButton: moduleProvider.isEnabled('aiChat')
          ? FloatingActionButton(
              backgroundColor: cs.primary,
              tooltip: t.translate('ai_support'),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () {
                AppNavigator.push(context, const AiChatScreen());
              },
              child: Icon(Icons.support_agent, color: cs.onPrimary, size: 28),
            )
          : null,

      body: RefreshIndicator(
        onRefresh: () => context.read<DashboardProvider>().fetchDashboardData(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // 1. HEADER
            FadeInDown(
              duration: const Duration(milliseconds: 800),
              child: Container(
                padding: EdgeInsets.fromLTRB(5.w, 4.h, 5.w, 2.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cs.primary,
                      cs.primary.withValues(
                        alpha: 0.8,
                      ), // Slightly lighter/different shade
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
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
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold, // w700
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                context.watch<AuthProvider>().user?.name ??
                                    t.translate('guest_user'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w900, // Extra Bold
                                  letterSpacing: -0.5,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            // NOTIFICATION BELL
                            Consumer<NotificationsProvider>(
                              builder: (context, notifProvider, child) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.15,
                                        ), // Glassmorphic feel
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          width: 1,
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          AppNavigator.push(
                                            context,
                                            const NotificationsScreen(),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.notifications_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                          minWidth: 40,
                                          minHeight: 40,
                                        ),
                                      ),
                                    ),
                                    if (notifProvider.unreadCount > 0)
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: cs.error,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: cs.primary,
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 20,
                                            minHeight: 20,
                                          ),
                                          child: Text(
                                            '${notifProvider.unreadCount}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(width: 3.w),

                            // PROFILE (No border, just clean image)
                            InkWell(
                              onTap: () {
                                AppNavigator.push(
                                  context,
                                  const ProfileScreen(),
                                );
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child:
                                      (context
                                                  .watch<AuthProvider>()
                                                  .user
                                                  ?.avatarUrl !=
                                              null &&
                                          context
                                              .watch<AuthProvider>()
                                              .user!
                                              .avatarUrl!
                                              .isNotEmpty)
                                      ? CachedNetworkImage(
                                          imageUrl: context
                                              .watch<AuthProvider>()
                                              .user!
                                              .avatarUrl!,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) {
                                            return Container(
                                              color: Colors.white,
                                              child: Center(
                                                child: Icon(
                                                  Icons.person_rounded,
                                                  size: 28,
                                                  color: cs.primary,
                                                ),
                                              ),
                                            );
                                          },
                                          placeholder: (context, url) =>
                                              Container(color: Colors.white),
                                        )
                                      : Container(
                                          color: Colors.white,
                                          child: Center(
                                            child: Icon(
                                              Icons.person_rounded,
                                              size: 20,
                                              color: cs.primary,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // DYNAMIC CONTENT
            Consumer<DashboardProvider>(
              builder: (context, dashboard, child) {
                if (dashboard.isLoading) {
                  return const DashboardShimmer();
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
                      ModuleVisibility(
                        module: 'carousel',
                        child: FadeIn(
                          // 🔹 FADE IN CAROUSEL
                          duration: const Duration(milliseconds: 800),
                          child: CtaCarousel(banners: data.addons.carousel),
                        ),
                      ),
                      SizedBox(height: 1.h),
                    ],

                    // SHORTS SECTION
                    ModuleVisibility(
                      module: 'shortVideos',
                      child: FadeInRight(
                        // 🔹 SLIDE IN SHORTS
                        delay: const Duration(milliseconds: 200),
                        child: const HomeShortsSection(),
                      ),
                    ),
                    SizedBox(height: 5.h),

                    // 4. QUICK ACTIONS (Static)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: FadeInUp(
                        // 🔹 FADE UP QUICK ACTIONS
                        delay: const Duration(milliseconds: 300),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: QuickCard(
                                icon: Icons.video_library_rounded,
                                title: t.translate('my_courses'),
                                subtitle: t.translate('completed_status'),
                                onTap: () {
                                  context.read<AnalyticsService>().logButtonTap(
                                    buttonName: 'my_courses_card',
                                    screenName: 'dashboard',
                                  );
                                  AppNavigator.push(
                                    context,
                                    const CoursesListScreen(),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: ModuleVisibility(
                                module: 'quizzes',
                                child: QuickCard(
                                  icon: Icons.quiz_rounded,
                                  title: t.translate('quizzes_title'),
                                  subtitle: t.translate('quizzes_subtitle'),
                                  onTap: () {
                                    context
                                        .read<AnalyticsService>()
                                        .logButtonTap(
                                          buttonName: 'quizzes_card',
                                          screenName: 'dashboard',
                                        );
                                    AppNavigator.push(
                                      context,
                                      const QuizTopicsScreen(),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // 6. DYNAMIC SECTIONS LOOP
                    ...data.sections.map((section) {
                      // CONTINUE WATCHING
                      if (section.key == 'continue') {
                        final courses = section.data.cast<CourseModel>();
                        if (courses.isEmpty) return const SizedBox();

                        return ModuleVisibility(
                          module: 'continueLearning',
                          child: Column(
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
                          ),
                        );
                      }

                      // COURSES
                      if (section.key == 'course' ||
                          section.key.contains('Popular') ||
                          section.key.contains('Recommended')) {
                        final courses = section.data.cast<CourseModel>();
                        if (courses.isEmpty) return const SizedBox();

                        return ModuleVisibility(
                          module: 'courses',
                          child: Column(
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
                          ),
                        );
                      }
                      // FREE VIDEOS
                      else if (section.key == 'freeVideos') {
                        final videos = section.data.cast<FreeVideoModel>();
                        if (videos.isEmpty) return const SizedBox();

                        return ModuleVisibility(
                          module: 'freeVideos',
                          child: Column(
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
                          ),
                        );
                      }
                      // BANNERS
                      else if (section.key == 'banner') {
                        final banners = section.data.cast<BannerModel>();
                        if (banners.isEmpty) return const SizedBox();

                        return ModuleVisibility(
                          module: 'banners',
                          child: Column(
                            children: [
                              InlineBanner(banners: banners),
                              SizedBox(height: 2.h),
                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                    }),

                    // 8. TOOLS
                    ModuleVisibility(
                      module: 'tools',
                      child: Column(
                        children: [
                          SectionHeader(
                            title: t.translate('tools_section_title'),
                            subtitle: t.translate('tools_section_subtitle'),
                          ),
                          SizedBox(height: 1.5.h),
                          const ToolsSection(),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                );
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: cs.surface,
          elevation: 0,
          selectedItemColor: cs.primary,
          unselectedItemColor: cs.onSurfaceVariant.withValues(alpha: 0.6),
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
            if (index < navActions.length && navActions[index] != null) {
              navActions[index]!();
            }
          },
          items: navItems,
        ),
      ),
    );
  }
}
