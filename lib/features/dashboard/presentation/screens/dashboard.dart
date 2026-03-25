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
import 'package:exim_lab/features/quiz/presentation/screens/quiz_topics_screen.dart';
import 'package:exim_lab/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/home_shorts_section.dart';
import 'package:exim_lab/features/shorts/presentation/screens/shorts_feed_screen.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/cta_carasoul.dart';
import 'package:exim_lab/features/gallery/presentation/screens/gallery_screen.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/horizontal_courses.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/inline_banner.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/section_header.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/tool_section.dart';
import 'package:exim_lab/features/freevideos/data/models/free_videos_model.dart';
import 'package:exim_lab/features/freevideos/presentation/widgets/free_video_section.dart';
import 'package:exim_lab/features/freevideos/presentation/screens/free_videos_details_screen.dart';
import 'package:exim_lab/features/news/presentation/screens/news_list_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:exim_lab/features/profile/presentation/screens/profile_screen.dart';
import 'package:exim_lab/features/module_manager/presentation/widgets/module_visibility.dart';
import 'package:exim_lab/features/module_manager/presentation/providers/module_provider.dart';
import 'package:exim_lab/features/journey/presentation/screens/import_journey_screen.dart';
import 'package:exim_lab/features/journey/presentation/screens/export_journey_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/dashboard_shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/premium_unlock_dialog.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/dashboard_continue_hero.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/dashboard_journey_bar.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/interest_dialog.dart';
import 'package:exim_lab/core/functions/pdf_utils.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final GlobalKey<_DashboardBodyState> _bodyKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      enableAutoScroll: true,
      onFinish: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('dashboard_v3_tour_seen', true);
        // Run post-tour logic (Interest Dialog etc.)
        _bodyKey.currentState?._checkTourStatus();
      },
      builder: (context) => _DashboardBody(key: _bodyKey),
    );
  }
}

class _DashboardBody extends StatefulWidget {
  const _DashboardBody({super.key});

  @override
  State<_DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<_DashboardBody> {
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _galleryHeaderKey = GlobalKey();
  final GlobalKey _notifKey = GlobalKey();
  final GlobalKey _userProfileKey = GlobalKey();

  final GlobalKey _carouselKey = GlobalKey();
  final GlobalKey _shortsKey = GlobalKey();

  final GlobalKey _coursesCardKey = GlobalKey();
  final GlobalKey _quizzesCardKey = GlobalKey();
  final GlobalKey _aiExpertCardKey = GlobalKey();
  final GlobalKey _galleryCardKey = GlobalKey();

  final GlobalKey _continueKey = GlobalKey();
  final GlobalKey _toolsKey = GlobalKey();
  final GlobalKey _freeVideosKey = GlobalKey();
  final GlobalKey _pdfPromoKey = GlobalKey();
  final GlobalKey _testimonialsKey = GlobalKey();
  final GlobalKey _socialKey = GlobalKey();
  final GlobalKey _counselingKey = GlobalKey();

  final GlobalKey _navHomeKey = GlobalKey();
  final GlobalKey _navShortsKey = GlobalKey();
  final GlobalKey _navCoursesKey = GlobalKey();
  final GlobalKey _navNewsKey = GlobalKey();
  final GlobalKey _navProfileKey = GlobalKey();

  final GlobalKey _popularCoursesKey = GlobalKey();
  final GlobalKey _masterclassKey = GlobalKey();

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
        if (mounted) {
          await context.read<AuthProvider>().refreshMembershipStatus();
        }

        // Show Tutorial if not seen, otherwise show Promo Banner immediately
        if (mounted) {
          _checkTourStatus();
        }
      }
    });
  }

  void triggerPromoBanner() {
    if (mounted) {
      final data = context.read<DashboardProvider>().data;
      if (data?.addons.popup != null) {
        _showPromoBanner(data!.addons.popup!);
      }
    }
  }

  Future<void> _checkTourStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final tourSeen = prefs.getBool('dashboard_v3_tour_seen') ?? false;

    if (!mounted) return;

    // Check interest status
    final user = context.read<AuthProvider>().user;
    final interestDialogShown = prefs.getBool('interest_dialog_shown') ?? false;

    if (!tourSeen && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final List<GlobalKey> showcaseList = [
          _headerKey,
          _notifKey,
          _userProfileKey,
          _galleryHeaderKey,
          _carouselKey,
          _shortsKey,
          _coursesCardKey,
          _quizzesCardKey,
          _aiExpertCardKey,
          _galleryCardKey,
          _continueKey,
          _popularCoursesKey,
          _toolsKey,
          _freeVideosKey,
          _pdfPromoKey,
          _testimonialsKey,
          _socialKey,
          _counselingKey,
          _navHomeKey,
          _navShortsKey,
          _navCoursesKey,
          _navNewsKey,
          _navProfileKey,
        ];

        // Filter out keys that are not present in the widget tree (e.g. empty sections)
        final List<GlobalKey> activeKeys = showcaseList.where((key) {
          return key.currentContext != null;
        }).toList();

        if (activeKeys.isNotEmpty && mounted) {
          ShowCaseWidget.of(context).startShowCase(activeKeys);
        }
      });
      _markTourSeen();
    } else {
      // Tour already seen, now check interest status or show promo banner
      final hasNoInterest =
          user?.interestedIn == null ||
          user!.interestedIn!.isEmpty ||
          user.interestedIn == '';

      if (hasNoInterest && !interestDialogShown && mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const InterestCaptureDialog(),
        );
        prefs.setBool('interest_dialog_shown', true);
      } else {
        triggerPromoBanner();
      }
    }
  }

  void _markTourSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dashboard_v3_tour_seen', true);
  }

  Widget _buildShowcase({
    required GlobalKey key,
    required String title,
    required String description,
    required Widget child,
    ShapeBorder shapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Showcase.withWidget(
      key: key,
      height: 280,
      width: screenWidth, // Full width overlay to allow centering tooltip
      targetShapeBorder: shapeBorder,
      container: Builder(
        builder: (tooltipContext) {
          // Providing local context to the tooltip content via callbacks
          // to avoid 'ShowCaseView context not found' error in detached overlays
          return _TutorialStepContent(
            targetKey: key,
            title: title,
            description: description,
            onNext: () => ShowCaseWidget.of(context).next(),
            onSkip: () => ShowCaseWidget.of(context).dismiss(),
          );
        },
      ),
      child: child,
    );
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

    // Parallel list of actions for each tab
    List<VoidCallback?> navActions = [null];

    if (moduleProvider.isEnabled('shortVideos')) {
      navItems.add(
        BottomNavigationBarItem(
          icon: const Icon(Icons.slow_motion_video_rounded),
          activeIcon: const Icon(Icons.slow_motion_video),
          label: t.translate('shorts'),
        ),
      );
      navActions.add(() {
        AppNavigator.push(context, const ShortsFeedScreen());
      });
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
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () =>
              context.read<DashboardProvider>().fetchDashboardData(),
          child: ListView(
            controller: _scrollController,
            cacheExtent: 1000,
            padding: EdgeInsets.zero,
            children: [
              // 1 & 2. NAVY TOP HEADER SECTION
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      cs.surfaceContainerHighest.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 1. HEADER
                    _buildShowcase(
                      key: _headerKey,
                      title: 'tut_header_title',
                      description: 'tut_header_desc',
                      child: Container(
                        padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
                        child: Row(
                          children: [
                            // 🏛️ LOGO
                            SizedBox(
                              height: 6.h,
                              child: Image.asset(
                                'assets/startup_india_import_export_academy_logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const Spacer(),

                            // 🔍 SEARCH
                            _buildHeaderCircleIcon(
                              icon: Icons.search_rounded,
                              onTap: () {
                                // TODO: Implement search
                              },
                              cs: cs,
                            ),
                            const SizedBox(width: 8),

                            // 🔔 NOTIFICATIONS
                            _buildNotificationIcon(cs),
                            const SizedBox(width: 8),

                            // 👤 PROFILE
                            _buildProfileIcon(cs),
                          ],
                        ),
                      ),
                    ),

                    // 1.5 ABOUT US SECTION
                    _buildAboutUs(context, cs, theme, t),

                    // 2. FEATURE TITLE
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "What would you like to ",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Text(
                                "Learn Today?",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF001A3D),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Container(
                            width: 15.w,
                            height: 1.5,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD32F2F),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 3. PREMIUM FEATURE CARDS SCROLL (Square Type)
                    SizedBox(height: 2.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.h,
                      ),
                      child: Row(
                        children: [
                          // 📸 GALLERY
                          _buildShowcase(
                            key: _galleryCardKey,
                            title: 'tut_gallery_title',
                            description: 'tut_gallery_desc',
                            child: _PremiumFeatureCard(
                              title: t.translate('gallery'),
                              icon: Icons.photo_library_rounded,
                              buttonLabel: "Success Stories",
                              themeColor: const Color(0xFF0D47A1),
                              onTap: () => AppNavigator.push(
                                context,
                                const GalleryScreen(),
                              ),
                            ),
                          ),
                          // 📊 MARKET UPDATES
                          _PremiumFeatureCard(
                            title: t.translate('market_updates'),
                            icon: Icons.trending_up_rounded,
                            buttonLabel: "Live Trends >",
                            themeColor: const Color(0xFFD32F2F),
                            onTap: () => AppNavigator.push(
                              context,
                              const NewsListScreen(),
                            ),
                          ),
                          // 🚢 IMPORT JOURNEY
                          _PremiumFeatureCard(
                            title: t.translate('start_import_journey'),
                            icon: Icons.directions_boat_rounded,
                            buttonLabel: "Continue >",
                            themeColor: const Color(0xFF0D47A1),
                            onTap: () => AppNavigator.push(
                              context,
                              const ImportJourneyScreen(),
                            ),
                          ),
                          // ✈️ EXPORT JOURNEY
                          _PremiumFeatureCard(
                            title: t.translate('start_export_journey'),
                            icon: Icons.airplanemode_active_rounded,
                            buttonLabel: "Start Learning",
                            themeColor: const Color(0xFFD32F2F),
                            onTap: () => AppNavigator.push(
                              context,
                              const ExportJourneyScreen(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 6. TRUST STRIP
                    _buildTrustStrip(cs),
                  ],
                ),
              ),

              // 3-END. DYNAMIC CONTENT
              Consumer<DashboardProvider>(
                builder: (context, dashboard, _) {
                  if (dashboard.isLoading) return const DashboardShimmer();
                  if (dashboard.error != null) {
                    return Center(child: Text('Error: ${dashboard.error}'));
                  }
                  final data = dashboard.data;
                  if (data == null) return const SizedBox();

                  bool assignedPopular = false;
                  bool assignedFreeVideos = false;

                  final continueSection = data.sections
                      .where((s) => s.key == 'continue')
                      .firstOrNull;
                  final continueCourses = continueSection != null
                      ? continueSection.data.cast<CourseModel>()
                      : <CourseModel>[];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),

                      // 3. CONTINUE LEARNING HERO
                      if (continueCourses.isNotEmpty)
                        ModuleVisibility(
                          module: 'continueLearning',
                          child: _buildShowcase(
                            key: _continueKey,
                            title: 'tut_continue_title',
                            description: 'tut_continue_desc',
                            child: Consumer<AuthProvider>(
                              builder: (context, auth, _) {
                                final isPremium = auth.user?.isPremium ?? false;
                                final course = continueCourses.first;
                                final isFree = course.basePrice == 0;
                                final isAccessible = isPremium || isFree;

                                return DashboardContinueHero(
                                  course: course,
                                  isLocked: !isAccessible,
                                  onTap: () {
                                    if (isAccessible) {
                                      AppNavigator.push(
                                        context,
                                        CourseDetailsScreen(
                                          courseId: course.id,
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (_) =>
                                            const PremiumUnlockDialog(),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      if (continueCourses.isNotEmpty) SizedBox(height: 2.h),

                      // 6. TOOLS (MOVED UP)
                      ModuleVisibility(
                        module: 'tools',
                        child: _buildShowcase(
                          key: _toolsKey,
                          title: 'tut_tools_title',
                          description: 'tut_tools_desc',
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      t.translate('tools_section_title'),
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18,
                                          ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'See All',
                                        style: TextStyle(
                                          color: cs.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Consumer<AuthProvider>(
                                builder: (context, auth, _) => ToolsSection(
                                  isPremium: auth.user?.isPremium ?? false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),

                      // 1.6 MASTERCLASS HIGHLIGHT
                      Consumer<DashboardProvider>(
                        builder: (context, dashboard, _) {
                          final data = dashboard.data;
                          if (data == null) return const SizedBox();
                          return _buildShowcase(
                            key: _masterclassKey,
                            title: 'Masterclass',
                            description:
                                'Watch our complete Import Export Roadmap',
                            child: _buildMasterclassHighlight(
                              context,
                              cs,
                              theme,
                              data,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 3.h),

                      // 4. YOUR LEARNING JOURNEY BAR
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          return DashboardJourneyBar(
                            completedCourses:
                                auth.user?.stats?.completedCourses ?? 0,
                            totalCourses: auth.user?.stats?.totalCourses ?? 10,
                            streakDays: auth.user?.stats?.learningStreak ?? 0,
                          );
                        },
                      ),
                      SizedBox(height: 2.h),

                      // 6. FREE GUIDE BANNER
                      _buildShowcase(
                        key: _pdfPromoKey,
                        title: 'tut_pdf_promo_title',
                        description: 'tut_pdf_promo_desc',
                        child: _buildFreePdfPromo(context, cs),
                      ),
                      SizedBox(height: 2.h),

                      // 4. QUICK ACTIONS ROW 2: QUIZZES & AI EXPERT (MOVED ABOVE CAROUSEL)
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 1.5.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildShowcase(
                                key: _quizzesCardKey,
                                title: 'tut_quizzes_title',
                                description: 'tut_quizzes_desc',
                                child: Consumer<AuthProvider>(
                                  builder: (context, auth, _) {
                                    final isPremium =
                                        auth.user?.isPremium ?? false;
                                    return _QuickActionCard(
                                      icon: Icons.quiz_rounded,
                                      label: t.translate('quizzes_title'),
                                      color:
                                          cs.primary, // Strict theme matching
                                      isLocked: !isPremium,
                                      onTap: () {
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
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: _buildShowcase(
                                key: _aiExpertCardKey,
                                title: 'tut_ai_expert_title',
                                description: 'tut_ai_expert_desc',
                                child: Consumer<AuthProvider>(
                                  builder: (context, auth, _) {
                                    final isPremium =
                                        auth.user?.isPremium ?? false;
                                    return _QuickActionCard(
                                      icon: Icons.smart_toy_rounded,
                                      label: t.translate('ai_expert'),
                                      color:
                                          cs.primary, // Strict theme matching
                                      isLocked: !isPremium,
                                      onTap: () {
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
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 6. CAROUSEL
                      if (data.addons.carousel.isNotEmpty) ...[
                        ModuleVisibility(
                          module: 'carousel',
                          child: FadeIn(
                            duration: const Duration(milliseconds: 800),
                            child: _buildShowcase(
                              key: _carouselKey,
                              title: 'tut_carousel_title',
                              description: 'tut_carousel_desc',
                              child: CtaCarousel(banners: data.addons.carousel),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],

                      // 7. SHORTS
                      ModuleVisibility(
                        module: 'shortVideos',
                        child: _buildShowcase(
                          key: _shortsKey,
                          title: 'tut_shorts_title',
                          description: 'tut_shorts_desc',
                          child: Consumer<AuthProvider>(
                            builder: (context, auth, _) {
                              final isPremium = auth.user?.isPremium ?? false;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Short Learning Videos',
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 18,
                                              ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            if (isPremium) {
                                              AppNavigator.push(
                                                context,
                                                const ShortsFeedScreen(),
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    const PremiumUnlockDialog(),
                                              );
                                            }
                                          },
                                          child: Text(
                                            'See All',
                                            style: TextStyle(
                                              color: cs.primary,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      AppNavigator.push(
                                        context,
                                        const ShortsFeedScreen(),
                                      );
                                    },
                                    child: const IgnorePointer(
                                      child: HomeShortsSection(),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),

                      // 10. DYNAMIC SECTIONS
                      ...data.sections.map((section) {
                        if ((section.key == 'course' ||
                                section.key.contains('Popular') ||
                                section.key.contains('Recommended')) &&
                            !assignedPopular) {
                          final courses = section.data.cast<CourseModel>();
                          if (courses.isEmpty) return const SizedBox();
                          assignedPopular = true;
                          return ModuleVisibility(
                            module: 'courses',
                            child: _buildShowcase(
                              key: _popularCoursesKey,
                              title: 'tut_popular_courses_title',
                              description: 'tut_popular_courses_desc',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          section.title,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                        Consumer<AuthProvider>(
                                          builder: (context, auth, _) {
                                            final isPremium =
                                                auth.user?.isPremium ?? false;
                                            return TextButton(
                                              onPressed: () {
                                                if (isPremium) {
                                                  AppNavigator.push(
                                                    context,
                                                    const CoursesListScreen(),
                                                  );
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        const PremiumUnlockDialog(),
                                                  );
                                                }
                                              },
                                              child: Text(
                                                'See All',
                                                style: TextStyle(
                                                  color: cs.primary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  HorizontalCourses(
                                    courses: courses,
                                    isPremium:
                                        context
                                            .read<AuthProvider>()
                                            .user
                                            ?.isPremium ??
                                        false,
                                  ),
                                  SizedBox(height: 2.h),
                                ],
                              ),
                            ),
                          );
                        } else if (section.key == 'freeVideos' &&
                            !assignedFreeVideos) {
                          final videos = section.data.cast<FreeVideoModel>();
                          if (videos.isEmpty) return const SizedBox();
                          assignedFreeVideos = true;
                          return ModuleVisibility(
                            module: 'freeVideos',
                            child: _buildShowcase(
                              key: _freeVideosKey,
                              title: 'tut_free_videos_title',
                              description: 'tut_free_videos_desc',
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
                            ),
                          );
                        } else if (section.key == 'banner') {
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

                      // 10. TESTIMONIALS
                      _buildShowcase(
                        key: _testimonialsKey,
                        title: 'tut_testimonials_title',
                        description: 'tut_testimonials_desc',
                        child: _buildTestimonials(context, cs, theme),
                      ),
                      SizedBox(height: 3.h),

                      // 11. SOCIAL
                      _buildShowcase(
                        key: _socialKey,
                        title: 'tut_social_title',
                        description: 'tut_social_desc',
                        child: _buildSocialConnect(context, cs, theme),
                      ),
                      SizedBox(height: 3.h),

                      // 12. FREE COUNSELING
                      _buildShowcase(
                        key: _counselingKey,
                        title: 'tut_counseling_title',
                        description: 'tut_counseling_desc',
                        child: _buildFreeCounseling(context, cs),
                      ),
                      SizedBox(height: 3.h),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: List.generate(navItems.length, (index) {
          final item = navItems[index];

          // Determine which key to use based on the label/order
          // Since items are dynamic, we need to match carefully
          final label = item.label!.toLowerCase();
          GlobalKey? key;
          String title = '';
          String desc = '';

          if (label == t.translate('home').toLowerCase()) {
            key = _navHomeKey;
            title = 'tut_nav_home_title';
            desc = 'tut_nav_home_desc';
          } else if (label == t.translate('shorts').toLowerCase()) {
            key = _navShortsKey;
            title = 'tut_nav_shorts_title';
            desc = 'tut_nav_shorts_desc';
          } else if (label == t.translate('courses').toLowerCase()) {
            key = _navCoursesKey;
            title = 'tut_nav_courses_title';
            desc = 'tut_nav_courses_desc';
          } else if (label == t.translate('news').toLowerCase()) {
            key = _navNewsKey;
            title = 'tut_nav_news_title';
            desc = 'tut_nav_news_desc';
          } else if (label == t.translate('profile').toLowerCase()) {
            key = _navProfileKey;
            title = 'tut_nav_profile_title';
            desc = 'tut_nav_profile_desc';
          }

          final destination = NavigationDestination(
            icon: item.icon,
            selectedIcon: item.activeIcon,
            label: item.label!,
          );

          if (key != null) {
            return _buildShowcase(
              key: key,
              title: title,
              description: desc,
              child: destination,
            );
          }

          return destination;
        }),
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index < navActions.length && navActions[index] != null) {
            navActions[index]!();
          }
        },
      ),
    );
  }

  Widget _buildAboutUs(
    BuildContext context,
    ColorScheme cs,
    ThemeData theme,
    AppLocalizations t,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      child: FadeInLeft(
        duration: const Duration(milliseconds: 800),
        child: SizedBox(
          width: double.infinity,
          height: 26
              .h, // Increased from 28.h for larger text and to prevent cutting
          child: Stack(
            children: [
              // 🎨 CUSTOM DRAWN BACKGROUND (Matches image exactly)
              CustomPaint(
                size: Size(double.infinity, 31.h),
                painter: _SirCardPainter(cs: cs),
              ),

              // 📦 CONTENT LAYER
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    // 👱‍♂️ PROFILE WITH ADAPTIVE GLOW RING
                    SizedBox(
                      width: 28.w, // Reduced from 35.w to give text more space
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: Size(25.w, 25.w), // Scaled down ring
                            painter: _ProfileGlowPainter(cs: cs),
                          ),
                          Container(
                            width: 19.w, // Scaled down portrait
                            height: 19.w,
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 9.w,
                              backgroundImage: const AssetImage(
                                'assets/ashok_sir_image.png',
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 4.w), // More spacing from profile
                    // 📝 TEXT CONTENT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 🏅 BADGES
                          Row(
                            children: [
                              _buildPillBadge("VERIFIED", cs.primary),
                              SizedBox(width: 2.w),
                              _buildPillBadge(
                                "48+ YEARS EXP.",
                                null,
                                isWhite: true,
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "Mr. Ashok Gupta Kinkkar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 1, // Prevent wrap if possible
                            overflow: TextOverflow.visible,
                          ),
                          Text(
                            "Founder & Global Mentor",
                            style: TextStyle(
                              color: const Color(0xFFFFD700), // Gold
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "\"Empowering India in Global Trade\"",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12.sp,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 🔘 RED "KNOW MORE" BUTTON
              Positioned(
                bottom: 1.h,
                right: 2.w, // Moved from 5.w to be more to the right
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showAboutUsBottomSheet(context, t, cs, theme),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w, // Increased for larger presence
                        vertical: 1.2.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFD32F2F,
                            ).withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Know More ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 14.sp, // Increased
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 14.sp, // Increased
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillBadge(String text, Color? color, {bool isWhite = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
        vertical: 0.5.h,
      ), // Increased padding
      decoration: BoxDecoration(
        color: isWhite
            ? Colors.white
            : (color?.withValues(alpha: 0.2) ?? Colors.white10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isWhite
              ? Colors.white
              : (color?.withValues(alpha: 0.3) ?? Colors.white24),
          width: 0.8,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isWhite ? const Color(0xFF001A3D) : Colors.white,
          fontSize: 10.5.sp, // Increased from 9.sp
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showAboutUsBottomSheet(
    BuildContext context,
    AppLocalizations t,
    ColorScheme cs,
    ThemeData theme,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            SizedBox(height: 1.5.h),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.translate('about_us_title'),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: cs.onSurfaceVariant),
                    style: IconButton.styleFrom(
                      backgroundColor: cs.surfaceContainerHighest,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: cs.primaryContainer.withValues(
                            alpha: 0.3,
                          ),
                          backgroundImage: const AssetImage(
                            'assets/ashok_sir_image.png',
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.translate('about_sir_title'),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: cs.onSurface,
                                ),
                              ),
                              Text(
                                t.translate('about_sir_desc'),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    _buildSectionHeader(cs, theme, "Our Vision"),
                    SizedBox(height: 1.h),
                    Text(
                      t.translate('about_us_text'),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    _buildSectionHeader(cs, theme, "Our Commitment"),
                    SizedBox(height: 1.h),
                    Text(
                      t.translate('about_us_text_full'),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ColorScheme cs, ThemeData theme, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildTrustStrip(ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              cs.surfaceContainerHighest.withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTrustItem(
              Icons.workspace_premium_rounded,
              "45+",
              "Years Experience",
              cs.secondary,
            ), // Red
            _buildTrustItem(
              Icons.school_rounded,
              "25K+",
              "Students Trained",
              cs.primary,
            ), // Navy
            _buildTrustItem(
              Icons.public_rounded,
              "100+",
              "Countries",
              cs.primary,
            ), // Blue accent
          ],
        ),
      ),
    );
  }

  Widget _buildTrustItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: 15.sp,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCircleIcon({
    required IconData icon,
    required VoidCallback onTap,
    required ColorScheme cs,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        iconSize: 22,
        icon: Icon(icon, color: cs.onSurface, size: 22),
      ),
    );
  }

  Widget _buildNotificationIcon(ColorScheme cs) {
    return Consumer<NotificationsProvider>(
      builder: (context, notifProvider, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            _buildHeaderCircleIcon(
              icon: Icons.notifications_none_rounded,
              onTap: () =>
                  AppNavigator.push(context, const NotificationsScreen()),
              cs: cs,
            ),
            if (notifProvider.unreadCount > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD32F2F),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '${notifProvider.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildProfileIcon(ColorScheme cs) {
    return InkWell(
      onTap: () => AppNavigator.push(context, const ProfileScreen()),
      borderRadius: BorderRadius.circular(40),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF0D47A1), width: 1.5),
        ),
        child: Container(
          height: 36,
          width: 36,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Consumer<AuthProvider>(
            builder: (context, auth, _) {
              final user = auth.user;
              if (user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty) {
                return CachedNetworkImage(
                  imageUrl: user.avatarUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, _) =>
                      Container(color: cs.surfaceContainerHighest),
                  errorWidget: (context, url, error) => Container(
                    color: cs.surfaceContainerHighest,
                    child: Icon(
                      Icons.person_rounded,
                      size: 22,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                );
              }
              return CircleAvatar(
                radius: 18,
                backgroundColor: cs.surfaceContainerHighest,
                child: Icon(
                  Icons.person_rounded,
                  size: 22,
                  color: cs.onSurfaceVariant,
                ),
              );
            },
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
          color: cs.primaryContainer.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.primary.withValues(alpha: 0.1)),
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
                      onPressed: () => _showPdfSelectionDialog(context),
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

  void _showPdfSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choose Your Guide"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text("Import Export Guide Vol 1"),
              onTap: () {
                Navigator.pop(context);
                PdfUtils.openAssetPdf('assets/pdf/Import_Export_Guide.pdf');
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text("Import Export Guide Vol 2"),
              onTap: () {
                Navigator.pop(context);
                PdfUtils.openAssetPdf('assets/pdf/Import_Export_Guide2.pdf');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
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
        "name": "Amit Sharma",
        "text":
            "The step-by-step guide on IEC registration and GST for exports was a lifesaver. Started my journey in weeks!",
        "rating": "5.0",
      },
      {
        "name": "Priya Patel",
        "text":
            "The industry insights on documentation are incredible. Best practical learning for Indian exporters.",
        "rating": "4.9",
      },
      {
        "name": "Rahul Verma",
        "text":
            "Finally understood the complexities of DGFT and custom clearance. The support group is very helpful.",
        "rating": "5.0",
      },
      {
        "name": "Vikram Singh",
        "text":
            "Cleared my first export shipment to Dubai with ease. The logistics module is very detailed and practical.",
        "rating": "4.8",
      },
      {
        "name": "Sneha Gupta",
        "text":
            "Best platform for women entrepreneurs. Very easy to follow and the mobile app UI is truly premium!",
        "rating": "5.0",
      },
      {
        "name": "Arjun Mehra",
        "text":
            "Quality courses and highly knowledgeable instructors. Learnt about shipping documents in just 2 days.",
        "rating": "4.9",
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
                                style: TextStyle(
                                  color: cs.primary,
                                  fontSize: 11.sp,
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
    final t = AppLocalizations.of(context);

    return Column(
      children: [
        SectionHeader(
          title: t.translate('follow_us'),
          subtitle: t.translate('join_trade_community'),
        ),
        SizedBox(height: 1.5.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                _socialIcon(
                  assetPath: 'assets/icons/youtube.png',
                  label: "Youtube 1",
                  color: const Color(0xFFFF0000),
                  onTap: () => launchUrl(
                    Uri.parse(
                      "https://youtu.be/f7eSa2jkUZM?si=Krq_Ke-2fPaj6obO",
                    ),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                _socialIcon(
                  assetPath: 'assets/icons/youtube.png',
                  label: "Youtube 2",
                  color: const Color(0xFFFF0000),
                  onTap: () => launchUrl(
                    Uri.parse(
                      "https://youtu.be/HiyHpVwbGgw?si=XcdW0LDkUDaRZoB8",
                    ),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                _socialIcon(
                  assetPath: 'assets/icons/instagram.png',
                  label: "Instagram",
                  color: const Color(0xFFE4405F),
                  onTap: () => launchUrl(
                    Uri.parse("https://www.instagram.com/siieadigital"),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                _socialIcon(
                  icon: Icons.language_rounded,
                  label: t.translate('website'),
                  color: const Color(0xFF0077B5),
                  onTap: () => launchUrl(
                    Uri.parse("https://www.siiea.in"),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _socialIcon({
    IconData? icon,
    String? assetPath,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          assetPath != null
              ? Image.asset(assetPath, width: 40, height: 40)
              : Icon(icon, color: color, size: 40),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
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
            colors: [cs.primary, cs.primary.withValues(alpha: 0.7)],
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

  Widget _buildMasterclassHighlight(
    BuildContext context,
    ColorScheme cs,
    ThemeData theme,
    DashboardResponse data,
  ) {
    // Find a 45-min video in the data if available, or use a placeholder
    FreeVideoModel? masterclassVideo;
    for (var section in data.sections) {
      if (section.key == 'freeVideos') {
        final videos = section.data.cast<FreeVideoModel>();
        masterclassVideo = videos.firstWhere(
          (v) => v.durationSeconds >= 2700,
          orElse: () => videos.first,
        );
        break;
      }
    }

    if (masterclassVideo == null) return const SizedBox();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✨ PREMIUM LABEL
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: cs.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: cs.secondary.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome_rounded, color: cs.secondary, size: 16),
                const SizedBox(width: 8),
                Text(
                  "FEATURED MASTERCLASS",
                  style: TextStyle(
                    color: cs.secondary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.5.h),

          FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: InkWell(
              onTap: () {
                AppNavigator.push(
                  context,
                  FreeVideoDetailsScreen(video: masterclassVideo!),
                );
              },
              borderRadius: BorderRadius.circular(32),
              child: Container(
                height: 28.h,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [cs.primary, cs.primary.withValues(alpha: 0.8)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // 🚢 BACKGROUND ILLUSTRATION (ON THE RIGHT)
                    Positioned(
                      right: -10.w,
                      top: -2.h,
                      bottom: -2.h,
                      child: Opacity(
                        opacity: 0.6,
                        child: Image.network(
                          'https://img.freepik.com/free-vector/global-logistics-network-background_23-2148161521.jpg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // 🌓 SUBTLE OVERLAY for Text Readability
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            cs.primary.withValues(alpha: 0.95),
                            cs.primary.withValues(alpha: 0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // 💎 GLASS DURATION BADGE
                    Positioned(
                      top: 16,
                      left: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          color: Colors.white.withValues(alpha: 0.1),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                color: Colors.white70,
                                size: 12,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "45 MINS",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // ▶ PLAY BUTTON (Floating on the right side)
                    Positioned(
                      right: 15.w,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              height: 48,
                              width: 48,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: cs.primary,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ✍️ ENGAGING CAPTIONS (Aligned Left)
                    Positioned(
                      bottom: 0,
                      top: 0,
                      left: 20,
                      right: 40.w, // Leave room for play button/illustration
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Master\nExport-Import",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                              letterSpacing: -1,
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                          Text(
                            "The Ultimate 2026\nBeginner-to-Pro\nRoadmap Training",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "Watch Now",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool isLocked;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(24),
      elevation: 2,
      shadowColor: color.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: color.withValues(alpha: 0.15),
              width: 1.5,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cs.surface, color.withValues(alpha: 0.08)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLocked ? Icons.lock_outline_rounded : icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumFeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String buttonLabel;
  final Color themeColor;
  final VoidCallback onTap;

  const _PremiumFeatureCard({
    required this.title,
    required this.icon,
    required this.buttonLabel,
    required this.themeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.w,
      height: 22.h, // Squarish type
      margin: EdgeInsets.only(right: 4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // 🌊 BOTTOM ACCENT WAVE
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 8.h,
              child: CustomPaint(painter: _CardWavePainter(color: themeColor)),
            ),

            // 🎨 ICON
            Positioned(
              top: 5.h,
              left: 0,
              right: 0,
              bottom: 7.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 35.sp,
                    height: 35.sp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: themeColor.withValues(alpha: 0.15),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    icon,
                    size: 36.sp, // Large and clear
                    color: themeColor.withValues(alpha: 0.9),
                  ),
                ],
              ),
            ),

            // 📝 TITLE
            Positioned(
              top: 2.h,
              left: 3.w,
              right: 3.w,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF001A3D),
                  fontWeight: FontWeight.w900,
                  fontSize: 13.sp, // Larger text
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // 🔘 ACTION PILL
            Positioned(
              bottom: 1.5.h,
              left: 3.w,
              right: 3.w,
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 0.6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              buttonLabel,
                              style: TextStyle(
                                color: themeColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 9.5.sp, // Larger text
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (buttonLabel.contains(">")) ...[
                            SizedBox(width: 1.w),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 14,
                              color: themeColor,
                            ),
                          ],
                        ],
                      ),
                    ),
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

class _CardWavePainter extends CustomPainter {
  final Color color;
  _CardWavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.05), color.withValues(alpha: 0.8)],
      ).createShader(Offset.zero & size);

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.1,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.9,
      size.width,
      size.height * 0.4,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TutorialStepContent extends StatefulWidget {
  final GlobalKey targetKey;
  final String title;
  final String description;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _TutorialStepContent({
    required this.targetKey,
    required this.title,
    required this.description,
    required this.onNext,
    required this.onSkip,
  });

  @override
  State<_TutorialStepContent> createState() => _TutorialStepContentState();
}

class _TutorialStepContentState extends State<_TutorialStepContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = widget.targetKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          alignment: 0.5,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth * 0.85, // Constrain tooltip width
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cs.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              t.translate(widget.title),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              t.translate(widget.description),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: widget.onSkip,
                  child: Text(
                    t.translate('skip'),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: widget.onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: cs.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    t.translate('tut_next'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 🎨 CUSTOM PAINTER FOR THE 3D NAVY CARD
class _SirCardPainter extends CustomPainter {
  final ColorScheme cs;
  _SirCardPainter({required this.cs});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [cs.primary, const Color(0xFF001A3D)],
      ).createShader(Offset.zero & size);

    final path = Path();
    const r = 24.0; // Corner radius

    // 📐 TRACING THE PREMIUM SHAPE
    path.moveTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);
    path.lineTo(size.width - r, 0);
    path.quadraticBezierTo(size.width, 0, size.width, r);
    path.lineTo(
      size.width,
      size.height * 0.65,
    ); // Start Step Down slightly earlier
    path.quadraticBezierTo(
      size.width,
      size.height * 0.75,
      size.width - r,
      size.height * 0.75,
    );
    path.lineTo(
      size.width * 0.55 + r,
      size.height * 0.75,
    ); // Moved left to 0.55
    path.quadraticBezierTo(
      size.width * 0.55,
      size.height * 0.75,
      size.width * 0.55,
      size.height * 0.85,
    );
    path.lineTo(size.width * 0.55, size.height - r);
    path.quadraticBezierTo(
      size.width * 0.55,
      size.height,
      size.width * 0.55 - r,
      size.height,
    );
    path.lineTo(r, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - r);
    path.close();

    // Draw Drop Shadow
    canvas.drawShadow(
      path.shift(const Offset(0, 10)),
      Colors.black54,
      15,
      true,
    );

    // Draw Background
    canvas.drawPath(path, paint);

    // Draw Globe/Grid lines (Subtle)
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width * 0.25, size.height * 0.5);
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, i * 35.0, gridPaint);
    }
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width * 0.6, size.height * 0.5),
      gridPaint,
    );

    // Draw Bevel Border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.4),
          Colors.transparent,
          Colors.white.withValues(alpha: 0.15),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 🎨 CUSTOM PAINTER FOR THE GLOWING PROFILE RING
class _ProfileGlowPainter extends CustomPainter {
  final ColorScheme cs;
  _ProfileGlowPainter({required this.cs});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer Glow
    final glowPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
      ..shader = SweepGradient(
        colors: [
          const Color(0xFFD32F2F),
          Colors.white,
          const Color(0xFF2196F3),
          const Color(0xFFD32F2F),
        ],
        stops: const [0.0, 0.4, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius - 4, glowPaint);

    // Solid Ring
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = Colors.white.withValues(alpha: 0.9);
    canvas.drawCircle(center, radius - 7, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
