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
import 'package:exim_lab/features/news/presentation/screens/news_list_screen.dart';
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
        final isPremium = context.read<AuthProvider>().user?.isPremium ?? false;
        if (isPremium) {
          AppNavigator.push(context, const ShortsFeedScreen());
        } else {
          showDialog(
            context: context,
            builder: (_) => const PremiumUnlockDialog(),
          );
        }
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
        final isPremium = context.read<AuthProvider>().user?.isPremium ?? false;
        if (isPremium) {
          AppNavigator.push(context, const CoursesListScreen());
        } else {
          showDialog(
            context: context,
            builder: (_) => const PremiumUnlockDialog(),
          );
        }
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
          cacheExtent: 1000,
          padding: EdgeInsets.zero,
          children: [
            // 1 & 2. ORANGE TOP HEADER SECTION
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                  // 1. HEADER
                  _buildShowcase(
                    key: _headerKey,
                    title: 'tut_header_title',
                    description: 'tut_header_desc',
                    child: Container(
                      padding: EdgeInsets.fromLTRB(5.w, 3.5.h, 5.w, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '👋 ',
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                    Text(
                                      '${t.translate('welcome_back')},',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            color: const Color(0xFF1D1F33),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.sp,
                                          ),
                                    ),
                                  ],
                                ),
                                if (context.watch<AuthProvider>().user?.name !=
                                        null &&
                                    context
                                        .watch<AuthProvider>()
                                        .user!
                                        .name!
                                        .isNotEmpty)
                                  Text(
                                    context.read<AuthProvider>().user!.name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF1D1F33),
                                          fontSize: 22.sp,
                                          letterSpacing: -0.5,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
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
                                        color: Color(0xFF1D1F33),
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
                                            color: Colors.black.withValues(
                                              alpha: 0.6,
                                            ),
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
                          const SizedBox(width: 4),
                          _buildShowcase(
                            key: _userProfileKey,
                            title: 'tut_profile_title',
                            description: 'tut_profile_desc',
                            child: InkWell(
                              onTap: () => AppNavigator.push(
                                context,
                                const ProfileScreen(),
                              ),
                              borderRadius: BorderRadius.circular(40),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.withValues(alpha: 0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Container(
                                  height: 38,
                                  width: 38,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Consumer<AuthProvider>(
                                    builder: (context, auth, _) {
                                      final user = auth.user;
                                      if (user?.avatarUrl != null &&
                                          user!.avatarUrl!.isNotEmpty) {
                                        return CachedNetworkImage(
                                          imageUrl: user.avatarUrl!,
                                          fit: BoxFit.cover,
                                          placeholder: (_, _) => Container(
                                            color: cs.primaryContainer,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                                Icons.person_rounded,
                                                size: 22,
                                                color: cs.primary,
                                              ),
                                        );
                                      }
                                      return CircleAvatar(
                                        radius: 19,
                                        backgroundColor: cs.primaryContainer,
                                        child: Icon(
                                          Icons.person_rounded,
                                          size: 22,
                                          color: cs.primary,
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
                    ),
                  ),

                  // 2. GALLERY / NEWS PILL ROW
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 0.5.h, 5.w, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'What would you like to learn today?',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),

                  // 3. GALLERY / NEWS CARD ROW
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 2.5.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildShowcase(
                            key: _galleryHeaderKey,
                            title: 'tut_gallery_title',
                            description: 'tut_gallery_desc',
                            child: Consumer<AuthProvider>(
                              builder: (context, auth, _) {
                                final isPremium = auth.user?.isPremium ?? false;
                                return _DashboardPillChip(
                                  icon: Icons.image_rounded,
                                  label: t.translate('gallery'),
                                  isLocked: !isPremium,
                                  onTap: () {
                                    if (isPremium) {
                                      AppNavigator.push(
                                        context,
                                        const GalleryScreen(),
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
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Consumer<AuthProvider>(
                            builder: (context, auth, _) {
                              final isPremium = auth.user?.isPremium ?? false;
                              return _DashboardPillChip(
                                icon: Icons.newspaper_rounded,
                                label: 'Latest News',
                                isLocked: !isPremium,
                                onTap: () {
                                  if (isPremium) {
                                    AppNavigator.push(
                                      context,
                                      const NewsListScreen(),
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
                      ],
                    ),
                  ),
                ],
              ),
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
                              return DashboardContinueHero(
                                course: continueCourses.first,
                                isLocked: !isPremium,
                                onTap: () {
                                  if (isPremium) {
                                    AppNavigator.push(
                                      context,
                                      CourseDetailsScreen(
                                        courseId: continueCourses.first.id,
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

                    // 4. YOUR LEARNING JOURNEY
                    Consumer<AuthProvider>(
                      builder: (context, auth, _) {
                        final isPremium = auth.user?.isPremium ?? false;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Your Learning Journey',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  TextButton(
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
                                      'View All',
                                      style: TextStyle(
                                        color: cs.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DashboardJourneyBar(
                              completedCourses:
                                  auth.user?.stats?.completedCourses ?? 0,
                              totalCourses:
                                  auth.user?.stats?.totalCourses ?? 10,
                              streakDays: auth.user?.stats?.learningStreak ?? 0,
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 2.h),

                    // 5. FREE GUIDE BANNER
                    _buildShowcase(
                      key: _pdfPromoKey,
                      title: 'tut_pdf_promo_title',
                      description: 'tut_pdf_promo_desc',
                      child: _buildFreePdfPromo(context, cs),
                    ),
                    SizedBox(height: 2.h),

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

                    // 8. TOOLS
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
                                    style: theme.textTheme.titleLarge?.copyWith(
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

                    // 9. DYNAMIC SECTIONS
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
              fontSize: 12.sp,
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
}

class _DashboardPillChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLocked;

  const _DashboardPillChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 5,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8A00).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isLocked ? Icons.lock_outline_rounded : icon,
                  color: const Color(0xFFFF8A00),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF1D1F33),
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                    letterSpacing: 0,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.withValues(alpha: 0.8),
                size: 20,
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
