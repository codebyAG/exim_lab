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
import 'package:url_launcher/url_launcher.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/premium_dialog.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/onboarding_dialog.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _actionsKey = GlobalKey();
  final GlobalKey _continueKey = GlobalKey();
  final GlobalKey _toolsKey = GlobalKey();
  final GlobalKey _bottomNavKey = GlobalKey();

  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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

          // PHASE 2: Check for onboarding status
          _checkOnboarding();
        }
        // Show Tutorial if not seen
        _checkTourStatus();
      }
    });
  }

  Future<void> _checkTourStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final tourSeen = prefs.getBool('dashboard_v2_tour_seen') ?? false;
    if (!tourSeen && mounted) {
      _initTargets();
      _showTutorial();
    }
  }

  void _markTourSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dashboard_v2_tour_seen', true);
  }

  void _initTargets() {
    final t = AppLocalizations.of(context);
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "header",
        keyTarget: _headerKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.translate('welcome_to_hub'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    t.translate('hub_description'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "actions",
        keyTarget: _actionsKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick Resources",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Quickly access product galleries and latest industry news from here.",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "tools",
        keyTarget: _toolsKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Business Tools",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Powerful calculators for Export Price, CBM, Duty, and Profit.",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "nav",
        keyTarget: _bottomNavKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Explore More",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Navigate through Courses, Updates, and your Profile easily.",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: _markTourSeen,
      onSkip: () {
        _markTourSeen();
        return true;
      },
    )..show(context: context);
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

  void _checkOnboarding() {
    final auth = context.read<AuthProvider>();
    final user = auth.user;

    // Show onboarding if name is missing or generic, or if interest is missing
    if (user != null &&
        (user.interest == null ||
            user.name == null ||
            user.name!.contains("User"))) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => OnboardingDialog(
          onContinue: (name, interest) async {
            try {
              final success = await auth.updateProfile({
                'name': name,
                'interest': interest,
              });
              if (success && mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Profile updated! Welcome aboard."),
                  ),
                );
              }
            } catch (e) {
              // Handle updating error
            }
          },
        ),
      );
    }
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          // Gallery
          _HeaderPill(
            icon: Icons.auto_awesome_motion_rounded,
            label: "Gallery",
            onTap: () {},
          ),
          SizedBox(width: 1.w),
          // News
          _HeaderPill(
            icon: Icons.newspaper_rounded,
            label: "News",
            onTap: () => AppNavigator.push(context, const NewsListScreen()),
          ),
          SizedBox(width: 1.w),
          // Notifications
          Consumer<NotificationsProvider>(
            builder: (context, notifProvider, child) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () =>
                        AppNavigator.push(context, const NotificationsScreen()),
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                    tooltip: 'Notifications',
                  ),
                  if (notifProvider.unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: cs.error,
                          shape: BoxShape.circle,
                          border: Border.all(color: cs.primary, width: 1.5),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '${notifProvider.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
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
          // Profile
          InkWell(
            onTap: () => AppNavigator.push(context, const ProfileScreen()),
            child: Container(
              margin: EdgeInsets.only(right: 4.w, left: 1.w),
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24,
              ),
              child: Container(
                height: 32,
                width: 32,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                clipBehavior: Clip.antiAlias,
                child: Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    final user = auth.user;
                    if (user?.avatarUrl != null &&
                        user!.avatarUrl!.isNotEmpty) {
                      return CachedNetworkImage(
                        imageUrl: user.avatarUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.white10),
                        errorWidget: (context, url, error) => Icon(
                          Icons.person_rounded,
                          size: 18,
                          color: cs.primary,
                        ),
                      );
                    }
                    return CircleAvatar(
                      radius: 16,
                      backgroundColor: cs.primaryContainer,
                      child: Icon(
                        Icons.person_rounded,
                        size: 18,
                        color: cs.primary,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,

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
                final isPremium =
                    context.read<AuthProvider>().user?.isPremium ?? false;
                if (isPremium) {
                  AppNavigator.push(context, const AiChatScreen());
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => const PremiumUnlockDialog(),
                  );
                }
              },
              child: Icon(Icons.support_agent, color: cs.onPrimary, size: 28),
            )
          : null,

      body: RefreshIndicator(
        onRefresh: () => context.read<DashboardProvider>().fetchDashboardData(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // 1. PREMIUM FLOATING HEADER
            Container(
              key: _headerKey,
              margin: EdgeInsets.only(bottom: 2.h),
              padding: EdgeInsets.fromLTRB(5.w, 6.h, 5.w, 3.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cs.primary,
                    cs.primary.withValues(alpha: 0.9),
                    Color.lerp(cs.primary, cs.secondary, 0.3)!,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.15),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative circle top-right
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  // Decorative circle bottom-left
                  Positioned(
                    bottom: -30,
                    left: -15,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.04),
                      ),
                    ),
                  ),
                  // Main content
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '👋 ',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    Text(
                                      t.translate('welcome_back'),
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: Colors.white.withValues(
                                              alpha: 0.85,
                                            ),
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  context.watch<AuthProvider>().user?.name ??
                                      t.translate('guest_user'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.auto_awesome_rounded,
                                        size: 13,
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        t.translate('continue_journey'),
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
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
                      SizedBox(height: 2.h),
                    ],

                    // SHORTS SECTION
                    ModuleVisibility(
                      module: 'shortVideos',
                      child: FadeInRight(
                        delay: const Duration(milliseconds: 200),
                        child: const HomeShortsSection(),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // 4. QUICK ACTIONS (Static)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Column(
                        children: [
                          FadeInUp(
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
                                      context
                                          .read<AnalyticsService>()
                                          .logButtonTap(
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
                                        final isPremium =
                                            context
                                                .read<AuthProvider>()
                                                .user
                                                ?.isPremium ??
                                            false;
                                        if (isPremium) {
                                          AppNavigator.push(
                                            context,
                                            const QuizTopicsScreen(),
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                const PremiumUnlockDialog(),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h),
                          FadeInUp(
                            delay: const Duration(milliseconds: 400),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: QuickCard(
                                    icon: Icons.smart_toy_rounded,
                                    title: t.translate('ai_expert'),
                                    subtitle: t.translate('ai_expert_sub'),
                                    onTap: () {
                                      final isPremium =
                                          context
                                              .read<AuthProvider>()
                                              .user
                                              ?.isPremium ??
                                          false;
                                      if (isPremium) {
                                        AppNavigator.push(
                                          context,
                                          const AiChatScreen(),
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (_) =>
                                              const PremiumUnlockDialog(),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: QuickCard(
                                    icon: Icons.folder_shared_rounded,
                                    title: "Resources",
                                    subtitle: "Books & PDFs",
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // 6. DYNAMIC SECTIONS LOOP
                    ...data.sections.map((section) {
                      // CONTINUE WATCHING
                      if (section.key == 'continue') {
                        final courses = section.data.cast<CourseModel>();
                        if (courses.isEmpty) return const SizedBox();

                        return ModuleVisibility(
                          module: 'continueLearning',
                          child: Column(
                            key: _continueKey,
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
                        key: _toolsKey,
                        children: [
                          SectionHeader(
                            title: t.translate('tools_section_title'),
                            subtitle: t.translate('tools_section_subtitle'),
                          ),
                          SizedBox(height: 1.5.h),
                          Consumer<AuthProvider>(
                            builder: (context, auth, _) {
                              return ToolsSection(
                                isPremium: auth.user?.isPremium ?? false,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // 9. FREE PDF PROMO (New)
                    _buildFreePdfPromo(context, cs),
                    SizedBox(height: 3.h),

                    // 10. TESTIMONIALS (New)
                    _buildTestimonials(context, cs, theme),
                    SizedBox(height: 3.h),

                    // 11. SOCIAL CONNECT (New)
                    _buildSocialConnect(context, cs, theme),
                    SizedBox(height: 3.h),

                    // 12. FREE COUNSELING (New)
                    _buildFreeCounseling(context, cs),
                    SizedBox(height: 3.h),
                  ],
                );
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        key: _bottomNavKey,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            backgroundColor: cs.surface,
            elevation: 0,
            selectedItemColor: cs.primary,
            unselectedItemColor: cs.onSurfaceVariant.withValues(alpha: 0.5),
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
            selectedIconTheme: const IconThemeData(size: 26),
            unselectedIconTheme: const IconThemeData(size: 24),
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
      ),
    );
  }

  Widget _buildFreePdfPromo(BuildContext context, ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F0),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.primary.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            const Text("🎁", style: TextStyle(fontSize: 40)),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Free Import Export Guide",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15.sp,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Complete beginner guide to start business",
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        foregroundColor: cs.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        "Download Free PDF →",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
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

  Widget _buildTestimonials(
    BuildContext context,
    ColorScheme cs,
    ThemeData theme,
  ) {
    final testimonials = [
      {
        "name": "John Doe",
        "text":
            "This course helped me start my export business in just 30 days! Highly recommended.",
        "rating": "5.0",
      },
      {
        "name": "Sarah Smith",
        "text":
            "The industry insights are incredible. Best investment for my career.",
        "rating": "4.9",
      },
      {
        "name": "Rahul Verma",
        "text":
            "Detailed content and great support. Finally understood the tax laws.",
        "rating": "5.0",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: "Student Success Stories",
          subtitle: "Real results from our premium members",
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 24.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            scrollDirection: Axis.horizontal,
            itemCount: testimonials.length,
            separatorBuilder: (_, _) => SizedBox(width: 4.w),
            itemBuilder: (context, index) {
              final t = testimonials[index];
              return Container(
                width: 80.w,
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: cs.primary.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.person,
                            color: cs.primary,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t["name"]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star, color: cs.primary, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    t["rating"]!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.format_quote_rounded,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      "\"${t["text"]}\"",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: cs.onSurfaceVariant,
                        fontSize: 13.sp,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSocialConnect(
    BuildContext context,
    ColorScheme cs,
    ThemeData theme,
  ) {
    return Column(
      children: [
        const SectionHeader(
          title: "Connect With Us",
          subtitle: "Join our growing trade community",
        ),
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _socialIcon(Icons.video_collection_rounded, Colors.red),
                _socialIcon(Icons.camera_alt_rounded, Colors.purple),
                _socialIcon(Icons.facebook_rounded, Colors.blue),
                _socialIcon(Icons.message_rounded, Colors.green),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _socialIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }

  Widget _buildFreeCounseling(BuildContext context, ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cs.primary, const Color(0xFFFFB703)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
            SizedBox(height: 2.h),
            const Text(
              "Still Confused?",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
            const Text(
              "Get Free Expert Counseling",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              "Book a 1:1 session with our industry experts",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final url = Uri.parse(
                    "https://wa.me/919871769042?text=I%20need%20free%20counseling%20for%20Import%20Export%20business",
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: cs.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Book Now →",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HeaderPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
