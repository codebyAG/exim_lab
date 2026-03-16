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
import 'package:exim_lab/features/gallery/presentation/screens/gallery_screen.dart';
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
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/premium_dialog.dart';

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
        // Show promo banner after the full tutorial finishes
        _bodyKey.currentState?.triggerPromoBanner();
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
    if (!tourSeen && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([
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
        ]);
      });
      _markTourSeen();
    } else {
      // If tour was already seen, show the promo banner immediately
      triggerPromoBanner();
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
          controller: _scrollController,
          padding: EdgeInsets.zero,
          children: [
            // 1. PREMIUM FLOATING HEADER
            _buildShowcase(
              key: _headerKey,
              title: 'tut_header_title',
              description: 'tut_header_desc',
              shapeBorder: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(bottom: 2.h),
                padding: EdgeInsets.fromLTRB(5.w, 6.h, 5.w, 4.h),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome & Name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
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
                                const SizedBox(height: 4),
                                Text(
                                  context.watch<AuthProvider>().user?.name ??
                                      t.translate('guest_user'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
                                        fontSize: 22.sp,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Gallery & News Pillars
                        Row(
                          children: [
                            Expanded(
                              child: _buildShowcase(
                                key: _galleryHeaderKey,
                                title: 'tut_gallery_title',
                                description: 'tut_gallery_desc',
                                child: _HeaderPill(
                                  icon: Icons.auto_awesome_motion_rounded,
                                  label: t.translate('gallery'),
                                  onTap: () => AppNavigator.push(
                                    context,
                                    const GalleryScreen(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _HeaderPill(
                                icon: Icons.newspaper_rounded,
                                label: t.translate('news'),
                                onTap: () => AppNavigator.push(
                                  context,
                                  const NewsListScreen(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Bottom icons row
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    t.translate('continue_journey'),
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.2,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            _buildShowcase(
                              key: _notifKey,
                              title: 'tut_notif_title',
                              description: 'tut_notif_desc',
                              child: Consumer<NotificationsProvider>(
                                builder: (context, notifProvider, child) {
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      IconButton(
                                        onPressed: () => AppNavigator.push(
                                          context,
                                          const NotificationsScreen(),
                                        ),
                                        icon: const Icon(
                                          Icons.notifications_outlined,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                      if (notifProvider.unreadCount > 0)
                                        Positioned(
                                          right: 4,
                                          top: 4,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: cs.error,
                                              shape: BoxShape.circle,
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 16,
                                              minHeight: 16,
                                            ),
                                            child: Text(
                                              '${notifProvider.unreadCount}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
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
                            ),
                            const SizedBox(width: 8),
                            _buildShowcase(
                              key: _userProfileKey,
                              title: 'tut_profile_title',
                              description: 'tut_profile_desc',
                              child: InkWell(
                                onTap: () => AppNavigator.push(
                                  context,
                                  const ProfileScreen(),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Container(
                                    height: 36,
                                    width: 36,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
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
                                                Container(
                                                  color: Colors.white10,
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                                      Icons.person_rounded,
                                                      size: 20,
                                                      color: Colors.white,
                                                    ),
                                          );
                                        }
                                        return const CircleAvatar(
                                          radius: 18,
                                          backgroundColor: Colors.white24,
                                          child: Icon(
                                            Icons.person_rounded,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        );
                                      },
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
                    // CAROUSEL
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

                    // SHORTS
                    ModuleVisibility(
                      module: 'shortVideos',
                      child: FadeInRight(
                        delay: const Duration(milliseconds: 200),
                        child: _buildShowcase(
                          key: _shortsKey,
                          title: 'tut_shorts_title',
                          description: 'tut_shorts_desc',
                          child: const HomeShortsSection(),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // QUICK ACTIONS
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Column(
                        children: [
                          FadeInUp(
                            delay: const Duration(milliseconds: 300),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildShowcase(
                                    key: _coursesCardKey,
                                    title: 'tut_my_courses_title',
                                    description: 'tut_my_courses_desc',
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
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: ModuleVisibility(
                                    module: 'quizzes',
                                    child: _buildShowcase(
                                      key: _quizzesCardKey,
                                      title: 'tut_quizzes_title',
                                      description: 'tut_quizzes_desc',
                                      child: QuickCard(
                                        icon: Icons.quiz_rounded,
                                        title: t.translate('quizzes_title'),
                                        subtitle: t.translate(
                                          'quizzes_subtitle',
                                        ),
                                        onTap: () {
                                          context
                                              .read<AnalyticsService>()
                                              .logButtonTap(
                                                buttonName: 'quizzes_card',
                                                screenName: 'dashboard',
                                              );
                                          if (context
                                                  .read<AuthProvider>()
                                                  .user
                                                  ?.isPremium ??
                                              false) {
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
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          FadeInUp(
                            delay: const Duration(milliseconds: 350),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildShowcase(
                                    key: _aiExpertCardKey,
                                    title: 'tut_ai_expert_title',
                                    description: 'tut_ai_expert_desc',
                                    child: QuickCard(
                                      icon: Icons.smart_toy_rounded,
                                      title: t.translate('ai_expert'),
                                      subtitle: t.translate('ai_expert_sub'),
                                      onTap: () {
                                        if (context
                                                .read<AuthProvider>()
                                                .user
                                                ?.isPremium ??
                                            false) {
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
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: _buildShowcase(
                                    key: _galleryCardKey,
                                    title: 'tut_gallery_card_title',
                                    description: 'tut_gallery_card_desc',
                                    child: QuickCard(
                                      icon: Icons.collections_rounded,
                                      title: t.translate('gallery'),
                                      subtitle: t.translate('gallery_subtitle'),
                                      onTap: () => AppNavigator.push(
                                        context,
                                        const GalleryScreen(),
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
                    SizedBox(height: 3.h),

                    // DYNAMIC SECTIONS
                    ...data.sections.map((section) {
                      if (section.key == 'continue') {
                        final courses = section.data.cast<CourseModel>();
                        if (courses.isEmpty) return const SizedBox();
                        return ModuleVisibility(
                          module: 'continueLearning',
                          child: _buildShowcase(
                            key: _continueKey,
                            title: 'tut_continue_title',
                            description: 'tut_continue_desc',
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                  ),
                                  child: Row(
                                    children: courses
                                        .map(
                                          (c) => ContinueCard(
                                            course: c,
                                            onTap: () => AppNavigator.push(
                                              context,
                                              CourseDetailsScreen(
                                                courseId: c.id,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                              ],
                            ),
                          ),
                        );
                      } else if (section.key == 'course' ||
                          section.key.contains('Popular') ||
                          section.key.contains('Recommended')) {
                        final courses = section.data.cast<CourseModel>();
                        if (courses.isEmpty) return const SizedBox();
                        return ModuleVisibility(
                          module: 'courses',
                          child: _buildShowcase(
                            key: _popularCoursesKey,
                            title: 'tut_popular_courses_title',
                            description: 'tut_popular_courses_desc',
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
                          ),
                        );
                      } else if (section.key == 'freeVideos') {
                        final videos = section.data.cast<FreeVideoModel>();
                        if (videos.isEmpty) return const SizedBox();
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

                    // TOOLS
                    ModuleVisibility(
                      module: 'tools',
                      child: _buildShowcase(
                        key: _toolsKey,
                        title: 'tut_tools_title',
                        description: 'tut_tools_desc',
                        child: Column(
                          children: [
                            SectionHeader(
                              title: t.translate('tools_section_title'),
                              subtitle: t.translate('tools_section_subtitle'),
                            ),
                            SizedBox(height: 1.5.h),
                            Consumer<AuthProvider>(
                              builder: (context, auth, _) => ToolsSection(
                                isPremium: auth.user?.isPremium ?? false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // 9. FREE PDF PROMO (New)
                    _buildShowcase(
                      key: _pdfPromoKey,
                      title: 'tut_pdf_promo_title',
                      description: 'tut_pdf_promo_desc',
                      child: _buildFreePdfPromo(context, cs),
                    ),
                    SizedBox(height: 3.h),

                    // 10. TESTIMONIALS (New)
                    _buildShowcase(
                      key: _testimonialsKey,
                      title: 'tut_testimonials_title',
                      description: 'tut_testimonials_desc',
                      child: _buildTestimonials(context, cs, theme),
                    ),
                    SizedBox(height: 3.h),

                    // 11. SOCIAL CONNECT (New)
                    _buildShowcase(
                      key: _socialKey,
                      title: 'tut_social_title',
                      description: 'tut_social_desc',
                      child: _buildSocialConnect(context, cs, theme),
                    ),
                    SizedBox(height: 3.h),

                    // 12. FREE COUNSELING (New)
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
              fontSize: 10.sp,
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
      margin: const EdgeInsets.symmetric(vertical: 4),
      width: double.infinity,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
