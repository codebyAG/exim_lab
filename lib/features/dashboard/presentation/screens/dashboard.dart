import 'dart:developer' as developer;
import 'package:exim_lab/common/widgets/promo_banner_dialog.dart';
import 'package:exim_lab/features/dashboard/presentation/painters/dashboard_icons_painter.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/premium_short_video_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/skill_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/certificate_mini_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/achieve_live_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/masterclass_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/popular_course_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/free_video_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/dashboard_footer.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:exim_lab/features/chatai/presentation/screens/ai_chat_screen.dart';
import 'package:exim_lab/features/courses/data/models/course_model.dart';
import 'package:exim_lab/features/freevideos/data/models/free_videos_model.dart';
import 'package:exim_lab/features/shorts/presentation/providers/shorts_provider.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/animated_search_bar.dart';
import 'package:exim_lab/features/courses/presentation/screens/course_search_delegate.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_details_screen.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_list_screen.dart';
import 'package:exim_lab/features/freevideos/presentation/screens/free_videos_details_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/export_price_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/import_calculator_screen.dart';
import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';
import 'package:exim_lab/features/quiz/presentation/screens/quiz_topics_screen.dart';
import 'package:exim_lab/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/gallery/presentation/screens/gallery_screen.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/inline_banner.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/tool_section.dart';
import 'package:exim_lab/features/news/presentation/screens/news_list_screen.dart';
import 'package:exim_lab/features/shorts/presentation/screens/shorts_feed_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:exim_lab/features/profile/presentation/screens/profile_screen.dart';
import 'package:exim_lab/features/module_manager/presentation/widgets/module_visibility.dart';
import 'package:exim_lab/features/module_manager/presentation/providers/module_provider.dart';
import 'package:exim_lab/features/journey/presentation/screens/import_journey_screen.dart';
import 'package:exim_lab/features/journey/presentation/screens/export_journey_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/dashboard_shimmer.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/premium_unlock_dialog.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/dashboard_continue_hero.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/dashboard_journey_bar.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/interest_dialog.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/founder_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/premium_feature_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/premium_action_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/free_pdf_promo_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/dashboard_modern_header.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/tutorial_step_content.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/premium_bottom_bar.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final GlobalKey<_DashboardBodyState> _bodyKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      enableAutoScroll: true,
      onFinish: () async {
        developer.log('🏁 ShowCase Tour Finished.', name: 'ONBOARDING');
        // Notify provider that tour is complete
        context.read<DashboardProvider>().markTourAsSeen();
        // Trigger next logical action (e.g. Interest Dialog or Promo)
        _bodyKey.currentState?._handlePostLoadActions();
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
      if (mounted) {
        context.read<AnalyticsService>().logEvent('home_view');
        final dashboardProvider = context.read<DashboardProvider>();

        // Load onboarding state (tour status etc.) alongside data
        await Future.wait([
          dashboardProvider.fetchDashboardData(),
          dashboardProvider.initOnboardingState(),
          context.read<NotificationsProvider>().fetchUnreadCount(),
          context.read<AuthProvider>().refreshMembershipStatus(),
        ]);

        if (mounted) {
          _handlePostLoadActions();
        }
      }
    });
  }

  Future<void> _handlePostLoadActions() async {
    if (!mounted) return;

    final dashboardProvider = context.read<DashboardProvider>();
    final user = context.read<AuthProvider>().user;

    final hasNoInterest =
        user?.interestedIn == null ||
        user!.interestedIn!.isEmpty ||
        user.interestedIn == '';

    final nextAction = dashboardProvider.getNextOnboardingAction(
      hasNoInterests: hasNoInterest,
    );

    developer.log(
      '🎬 Onboarding Action Triggered -> [$nextAction]',
      name: 'ONBOARDING',
    );

    switch (nextAction) {
      case DashboardOnboardingAction.startTour:
        _startShowcase();
        break;
      case DashboardOnboardingAction.showInterestDialog:
        _showInterestDialog();
        break;
      case DashboardOnboardingAction.showPromoBanner:
        _triggerPromoBanner();
        break;
      case DashboardOnboardingAction.none:
        developer.log('✅ No onboarding actions pending.', name: 'ONBOARDING');
        break;
    }
  }

  void _startShowcase() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Small delay to ensure all list items have performed their first paint
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      final List<GlobalKey> showcaseList = [
        _headerKey,
        _notifKey,
        _userProfileKey,
        _galleryHeaderKey,
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

      final List<GlobalKey> activeKeys = showcaseList
          .where((key) => key.currentContext != null)
          .toList();

      developer.log(
        '🔍 Tour Keys Found: ${activeKeys.length} / ${showcaseList.length}',
        name: 'ONBOARDING',
      );

      if (activeKeys.isNotEmpty && mounted) {
        developer.log('🚀 Starting ShowCase Tour...', name: 'ONBOARDING');
        ShowCaseWidget.of(context).startShowCase(activeKeys);
      } else {
        developer.log(
          '⚠️ No visible keys found for tour. Marking as seen to prevent UI blockage.',
          name: 'ONBOARDING',
        );
        // Only mark as seen if we've truly given it a chance to render
        context.read<DashboardProvider>().markTourAsSeen();
        _handlePostLoadActions();
      }
    });
  }

  void _showInterestDialog() {
    developer.log('🎯 Pushing InterestCaptureDialog...', name: 'ONBOARDING');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const InterestCaptureDialog(),
    ).then((_) {
      if (mounted) {
        context.read<DashboardProvider>().markInterestDialogAsShown();
        _handlePostLoadActions(); // Check if promo should be shown after dialog
      }
    });
  }

  Future<void> _triggerPromoBanner() async {
    // Safety delay to ensure dashboard build and tour logic have settled
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    final data = context.read<DashboardProvider>().data;
    if (data?.addons.popup != null) {
      developer.log('🎁 Pushing PromoBannerDialog...', name: 'ONBOARDING');
      _showPromoBanner(data!.addons.popup!);
    }
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
          return TutorialStepContent(
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

    // Build Navigation schema
    final navConfig = _buildNavigationConfig(context, t, moduleProvider);
    final navActions = navConfig.actions;

    return Scaffold(
      backgroundColor: const Color(0xFF020C28), // Deep Premium Navy
      floatingActionButton: moduleProvider.isEnabled('aiChat')
          ? FloatingActionButton(
              backgroundColor: cs.primary,
              tooltip: t.translate('ai_support'),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () => _handlePremiumGatedTap(
                context: context,
                sectionName: 'Floating Action: AI Support',
                action: () => AppNavigator.push(context, const AiChatScreen()),
              ),
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
            // 🏆 MODERN PREMIUM HEADER SECTION
            _buildShowcase(
              key: _headerKey,
              title: 'tut_header_title',
              description: 'tut_header_desc',
              child: const DashboardModernHeader(),
            ),

            // 🔍 PREMIUM SEARCH BAR
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 1.h),
              child: AnimatedSearchBar(
                hints: const [
                  "Search Courses...",
                  "How to Export?",
                  "Find HSN Code",
                  "Market Trends",
                ],
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: CourseSearchDelegate(),
                  );
                },
              ),
            ),

            // 1.5 ABOUT US SECTION
            const FounderCard(),

            // 📊 YOUR PROGRESS (MOVED UP)
            Consumer<DashboardProvider>(
              builder: (context, dashboard, _) {
                return Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return DashboardJourneyBar(
                      completedCourses: auth.user?.stats?.completedCourses ?? 0,
                      totalCourses: auth.user?.stats?.totalCourses ?? 10,
                      streakDays: auth.user?.stats?.learningStreak ?? 0,
                    );
                  },
                );
              },
            ),

            // 🛠️ PREMIUM SEPARATOR
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFC8151B), // Premium Red
                      const Color(0xFFC8151B).withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),

            // 2. FEATURE TITLE
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                children: [
                  const TextSpan(text: "🚀 Explore "),
                  TextSpan(
                    text: "Gallery",
                    style: TextStyle(color: const Color(0xFFFFD000)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.5.h),
            // 3. PREMIUM FEATURE CARDS SCROLL (Square Type)
            SizedBox(height: 0.8.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              child: Row(
                children: [
                  // 📸 GALLERY
                  _buildShowcase(
                    key: _galleryCardKey,
                    title: 'tut_gallery_title',
                    description: 'tut_gallery_desc',
                    child: PremiumFeatureCard(
                      title: t.translate('gallery'),
                      icon: Icons.photo_library_rounded,
                      painter: GalleryIconPainter(),
                      buttonLabel: "Success Stories",
                      themeColor: const Color(0xFF0D47A1),
                      onTap: () =>
                          AppNavigator.push(context, const GalleryScreen()),
                    ),
                  ),
                  // 📊 MARKET UPDATES
                  PremiumFeatureCard(
                    title: t.translate('market_updates'),
                    icon: Icons.trending_up_rounded,
                    painter: MarketUpdatesIconPainter(),
                    buttonLabel: "Live Trends >",
                    themeColor: const Color(0xFFD32F2F),
                    onTap: () =>
                        AppNavigator.push(context, const NewsListScreen()),
                  ),
                  // 🚢 IMPORT JOURNEY
                  PremiumFeatureCard(
                    title: t.translate('start_import_journey'),
                    icon: Icons.directions_boat_rounded,
                    painter: ImportJourneyIconPainter(),
                    buttonLabel: "Continue >",
                    themeColor: const Color(0xFF001A3D),
                    onTap: () =>
                        AppNavigator.push(context, const ImportJourneyScreen()),
                  ),
                  // ✈️ EXPORT JOURNEY
                  PremiumFeatureCard(
                    title: t.translate('start_export_journey'),
                    icon: Icons.airplanemode_active_rounded,
                    painter: ExportJourneyIconPainter(),
                    buttonLabel: "Start Learning >",
                    themeColor: const Color(
                      0xFFC06014,
                    ), // Premium Orange/Bronze
                    onTap: () =>
                        AppNavigator.push(context, const ExportJourneyScreen()),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),

            // 🛠️ 4. SKILLS YOU'LL LEARN (Header + 2x2 Grid)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 20.sp, // Ultra Increased
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                      children: [
                        const TextSpan(text: "Skills You'll "),
                        TextSpan(
                          text: "Learn",
                          style: TextStyle(color: const Color(0xFFFFD000)),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      developer.log(
                        '📂 Navigation -> Skills: See All',
                        name: 'NAVIGATION',
                      );
                      AppNavigator.push(context, const CoursesListScreen());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 0.6.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E5FFF).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF1E5FFF).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        "See All →",
                        style: TextStyle(
                          color: const Color(0xFF1E5FFF),
                          fontSize: 12.5.sp, // Increased
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            // 🔥 SKILLS GRID
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: GridView.count(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 3.w,
                crossAxisSpacing: 3.w,
                childAspectRatio: 1.15,
                children: [
                  SkillCard(
                    title: "Export Price Calculator",
                    subtitle: "Profit · Pricing",
                    badge: "TOOL",
                    gradientColors: const [
                      Color(0xFF0A2066),
                      Color(0xFF153580),
                    ],
                    painter: ExportPriceIconPainter(),
                    onTap: () {
                      developer.log(
                        '📂 Navigation -> Tool: Export Price Calculator',
                        name: 'NAVIGATION',
                      );
                      AppNavigator.push(
                        context,
                        const ExportPriceCalculatorScreen(),
                      );
                    },
                  ),
                  SkillCard(
                    title: "Import Calculator",
                    subtitle: "Cost · Duty",
                    badge: "TOOL",
                    gradientColors: const [
                      Color(0xFF5A0006),
                      Color(0xFF8B000C),
                    ],
                    painter: ImportCalcIconPainter(),
                    onTap: () {
                      developer.log(
                        '📂 Navigation -> Tool: Import Calculator',
                        name: 'NAVIGATION',
                      );
                      AppNavigator.push(
                        context,
                        const ImportCalculatorScreen(),
                      );
                    },
                  ),
                  SkillCard(
                    title: "Logistics & Shipping",
                    subtitle: "Routes · Freight",
                    badge: "MODULE",
                    gradientColors: const [
                      Color(0xFF003A70),
                      Color(0xFF005AAA),
                    ],
                    painter: LogisticsIconPainter(),
                    onTap: () {
                      developer.log(
                        '📂 Navigation -> Module: Logistics',
                        name: 'NAVIGATION',
                      );
                      AppNavigator.push(context, const CoursesListScreen());
                    },
                  ),
                  SkillCard(
                    title: "Buyer Acquisition",
                    subtitle: "Leads · Markets",
                    badge: "MODULE",
                    gradientColors: const [
                      Color(0xFF4A2800),
                      Color(0xFF7A4400),
                    ],
                    painter: BuyerIconPainter(),
                    onTap: () {
                      developer.log(
                        '📂 Navigation -> Module: Buyer Acquisition',
                        name: 'NAVIGATION',
                      );
                      AppNavigator.push(context, const CoursesListScreen());
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.5.h),

            // 🏅 5. CERTIFICATES MINI ROW
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                children: [
                  CertificateMiniCard(
                    title: "Export",
                    level: "Beginner",
                    levelColor: const Color(0xFF88AAFF),
                    gradientColors: const [
                      Color(0xFF0A2066),
                      Color(0xFF1040C1),
                    ],
                    icon: CustomPaint(painter: CertStarIconPainter()),
                  ),
                  CertificateMiniCard(
                    title: "Documentation",
                    level: "Expert",
                    levelColor: const Color(0xFFFF9999),
                    gradientColors: const [
                      Color(0xFF5A0006),
                      Color(0xFFC8151B),
                    ],
                    icon: Text("📋", style: TextStyle(fontSize: 16.sp)),
                  ),
                  CertificateMiniCard(
                    title: "Trade",
                    level: "Analyst",
                    levelColor: const Color(0xFF88AAFF),
                    gradientColors: const [
                      Color(0xFF0A2066),
                      Color(0xFF1040C1),
                    ],
                    icon: Text("⚔️", style: TextStyle(fontSize: 16.sp)),
                  ),
                  CertificateMiniCard(
                    title: "Trade",
                    level: "Advanced",
                    levelColor: const Color(0xFFFFD000),
                    gradientColors: const [
                      Color(0xFF4A2800),
                      Color(0xFF8B5500),
                    ],
                    icon: Text("🏆", style: TextStyle(fontSize: 16.sp)),
                  ),
                ],
              ),
            ),

            SizedBox(height: 1.h),

            const AchieveLiveCard(),
            SizedBox(height: 1.h),

            // 🚀 4.6 FEATURED MASTERCLASS
            const MasterclassCard(),
            SizedBox(height: 1.5.h),

            // 🛠️ PREMIUM DIVIDER
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFC8151B),
                      const Color(0xFFC8151B).withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),

            SizedBox(height: 1.h),

            SizedBox(height: 1.h),
            Consumer<DashboardProvider>(
              builder: (context, dashboard, _) {
                if (dashboard.isLoading) return const DashboardShimmer();
                if (dashboard.error != null) {
                  return Center(child: Text('Error: ${dashboard.error}'));
                }
                final data = dashboard.data;
                if (data == null) return const SizedBox();

                final freeVideoSection = dashboard.freeVideoSection;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (freeVideoSection != null &&
                        freeVideoSection.data.isNotEmpty) ...[
                      SizedBox(height: 2.5.h),
                      // 🎁 4.9 FREE VIDEOS SECTION
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                                children: [
                                  const TextSpan(text: "🎁 Free "),
                                  TextSpan(
                                    text: "Videos",
                                    style: TextStyle(
                                      color: const Color(0xFFFFD000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                developer.log(
                                  '📂 Navigation -> Free Videos: View All',
                                  name: 'NAVIGATION',
                                );
                                AppNavigator.push(
                                  context,
                                  const CoursesListScreen(),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 0.8.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: const Color(0xFF1E5FFF),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  "View All →",
                                  style: TextStyle(
                                    color: const Color(0xFF1E5FFF),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(left: 5.w, bottom: 2.h),
                        child: Row(
                          children: freeVideoSection.data.cast<FreeVideoModel>().map((
                            video,
                          ) {
                            return FreeVideoCard(
                              title: video.title,
                              thumbnailUrl: video.thumbnailUrl,
                              durationSeconds: video.durationSeconds,
                              views:
                                  "128K views", // Mock view count as it's not in the model
                              timeAgo:
                                  "6 months ago", // Mock time ago as it's not in the model
                              onTap: () {
                                developer.log(
                                  '📂 Navigation -> Free Video: ${video.title}',
                                  name: 'NAVIGATION',
                                );
                                AppNavigator.push(
                                  context,
                                  FreeVideoDetailsScreen(video: video),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],

                    // ⚡ 4.10 SHORT VIDEOS SECTION
                    Consumer<ShortsProvider>(
                      builder: (context, shortsProvider, _) {
                        if (shortsProvider.shorts.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 1.5.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                      children: [
                                        const TextSpan(text: "⚡ Short "),
                                        TextSpan(
                                          text: "Videos",
                                          style: TextStyle(
                                            color: const Color(0xFFFFD000),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      developer.log(
                                        '📂 Navigation -> Shorts: View All',
                                        name: 'NAVIGATION',
                                      );
                                      AppNavigator.push(
                                        context,
                                        const ShortsFeedScreen(),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                        vertical: 0.8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        border: Border.all(
                                          color: const Color(0xFF1E5FFF),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text(
                                        "View All →",
                                        style: TextStyle(
                                          color: const Color(0xFF1E5FFF),
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(left: 5.w, bottom: 2.h),
                              child: Row(
                                children: [
                                  for (
                                    int i = 0;
                                    i < shortsProvider.shorts.length;
                                    i++
                                  )
                                    Builder(
                                      builder: (context) {
                                        final short = shortsProvider.shorts[i];

                                        // Extract actual thumbnail from YouTube URL
                                        final String? videoId =
                                            YoutubePlayer.convertUrlToId(
                                              short.videoUrl,
                                            );
                                        final String thumbnailUrl =
                                            videoId != null
                                            ? 'https://img.youtube.com/vi/$videoId/0.jpg'
                                            : short.thumbnailUrl;

                                        // Array of modern premium gradients
                                        final gradients = [
                                          [
                                            const Color(0xFF0A2066),
                                            const Color(0xFF1E5FFF),
                                          ], // Blue
                                          [
                                            const Color(0xFF6B0000),
                                            const Color(0xFFC8151B),
                                          ], // Red
                                          [
                                            const Color(0xFF994400),
                                            const Color(0xFFFF8800),
                                          ], // Orange
                                          [
                                            const Color(0xFF004411),
                                            const Color(0xFF008822),
                                          ], // Green
                                        ];

                                        return PremiumShortVideoCard(
                                          title: short.title,
                                          thumbnailUrl: thumbnailUrl,
                                          viewCount: short.viewCount > 0
                                              ? short.viewCount
                                              : 45000 +
                                                    (i *
                                                        1200), // Fallback for aesthetic
                                          durationSeconds:
                                              short.durationSeconds > 0
                                              ? short.durationSeconds
                                              : 55 + (i * 5),
                                          gradientColors:
                                              gradients[i % gradients.length],
                                          onTap: () {
                                            AppNavigator.push(
                                              context,
                                              ShortsFeedScreen(initialIndex: i),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: 1.h),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 0.8.h),

                    // 3. CONTINUE LEARNING HERO
                    if (dashboard.continueCourses.isNotEmpty)
                      ModuleVisibility(
                        module: 'continueLearning',
                        child: _buildShowcase(
                          key: _continueKey,
                          title: 'tut_continue_title',
                          description: 'tut_continue_desc',
                          child: Consumer<AuthProvider>(
                            builder: (context, auth, _) {
                              final isPremium = auth.user?.isPremium ?? false;
                              final course = dashboard.continueCourses.first;
                              final isFree = course.basePrice == 0;
                              final isAccessible = isPremium || isFree;

                              return DashboardContinueHero(
                                course: course,
                                isLocked: !isAccessible,
                                onTap: () => _handlePremiumGatedTap(
                                  context: context,
                                  sectionName:
                                      'Continue Learning: ${course.title}',
                                  isFree: isFree,
                                  action: () => AppNavigator.push(
                                    context,
                                    CourseDetailsScreen(courseId: course.id),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    if (dashboard.continueCourses.isNotEmpty)
                      SizedBox(height: 0.8.h),

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
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                      children: [
                                        const TextSpan(text: "🛠️ Practical "),
                                        TextSpan(
                                          text: "Tools",
                                          style: TextStyle(
                                            color: const Color(0xFFFFD000),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      developer.log(
                                        '📂 Navigation -> Tools: See All',
                                        name: 'NAVIGATION',
                                      );
                                      AppNavigator.push(
                                        context,
                                        const CoursesListScreen(),
                                      );
                                    },
                                    child: Text(
                                      'See All',
                                      style: TextStyle(
                                        color: const Color(0xFF1E5FFF),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12.sp,
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
                    SizedBox(height: 0.8.h),

                    // 6. FREE GUIDE BANNER
                    _buildShowcase(
                      key: _pdfPromoKey,
                      title: 'tut_pdf_promo_title',
                      description: 'tut_pdf_promo_desc',
                      child: const FreePdfPromoCard(),
                    ),
                    SizedBox(height: 0.8.h),

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
                                  return PremiumActionCard(
                                    painter: QuizTopicPainter(),
                                    label: t.translate('quizzes_title'),
                                    color: const Color(
                                      0xFFFFD000,
                                    ), // Premium Gold
                                    isLocked: !isPremium,
                                    onTap: () => _handlePremiumGatedTap(
                                      context: context,
                                      sectionName: 'Dashboard: Quizzes',
                                      action: () => AppNavigator.push(
                                        context,
                                        const QuizTopicsScreen(),
                                      ),
                                    ),
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
                                  return PremiumActionCard(
                                    painter: AiExpertPainter(),
                                    label: t.translate('ai_expert'),
                                    color: const Color(0xFF1E5FFF), // AI Blue
                                    isLocked: !isPremium,
                                    onTap: () => _handlePremiumGatedTap(
                                      context: context,
                                      sectionName: 'Dashboard: AI Expert',
                                      action: () => AppNavigator.push(
                                        context,
                                        const AiChatScreen(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 10. DYNAMIC SECTIONS (Unified Approach)

                    // Popular Courses
                    if (dashboard.popularCourseSection != null)
                      _buildDynamicCourseBlock(
                        context,
                        dashboard.popularCourseSection!,
                        _popularCoursesKey,
                        'courses',
                        "🔥 Popular ",
                        "Courses",
                      ),

                    // Recommended Courses
                    if (dashboard.recommendedCourseSection != null)
                      _buildDynamicCourseBlock(
                        context,
                        dashboard.recommendedCourseSection!,
                        null,
                        'courses',
                        "🎯 Recommended ",
                        "for You",
                      ),

                    // All Courses
                    if (dashboard.allCourseSection != null)
                      _buildDynamicCourseBlock(
                        context,
                        dashboard.allCourseSection!,
                        null,
                        'courses',
                        "📚 All ",
                        "Courses",
                      ),

                    // Inline Banners
                    if (dashboard.inlineBanners.isNotEmpty)
                      ModuleVisibility(
                        module: 'banners',
                        child: Column(
                          children: [
                            InlineBanner(banners: dashboard.inlineBanners),
                            SizedBox(height: 0.8.h),
                          ],
                        ),
                      ),

                    const DashboardFooter(),
                    SizedBox(height: 8.h), // Padding for pinned navigation bar
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: PremiumBottomBar(
        items: navConfig.schema,
        selectedIndex: 0,
        onItemSelected: (index) {
          if (index < navActions.length && navActions[index] != null) {
            navActions[index]!();
          }
        },
      ),
    );
  }

  _NavigationConfig _buildNavigationConfig(
    BuildContext context,
    AppLocalizations t,
    ModuleProvider moduleProvider,
  ) {
    final dashboardProvider = context.read<DashboardProvider>();
    final schema = dashboardProvider.getNavigationSchema(moduleProvider);

    List<BottomNavigationBarItem> navItems = [];
    List<VoidCallback?> navActions = [];

    for (var item in schema) {
      navItems.add(
        BottomNavigationBarItem(
          icon: Icon(item.icon),
          activeIcon: Icon(item.activeIcon),
          label: t.translate(item.labelKey),
        ),
      );

      switch (item.identifier) {
        case 'home':
          navActions.add(null);
          break;
        case 'shorts':
          navActions.add(
            () => AppNavigator.push(context, const ShortsFeedScreen()),
          );
          break;
        case 'courses':
          navActions.add(
            () => AppNavigator.push(context, const CoursesListScreen()),
          );
          break;
        case 'news':
          navActions.add(
            () => AppNavigator.push(context, const NewsListScreen()),
          );
          break;
        case 'profile':
          navActions.add(
            () => AppNavigator.push(context, const ProfileScreen()),
          );
          break;
      }
    }

    return _NavigationConfig(
      items: navItems,
      actions: navActions,
      schema: schema,
    );
  }

  void _handlePremiumGatedTap({
    required BuildContext context,
    required VoidCallback action,
    required String sectionName,
    bool isFree = false,
  }) {
    final isPremium = context.read<AuthProvider>().user?.isPremium ?? false;

    developer.log(
      '🛡️ Gated Access Check -> [$sectionName]\n'
      '   - User Premium: $isPremium\n'
      '   - Section Free: $isFree\n'
      '   - Result: ${isPremium || isFree ? "✅ ACCESS GRANTED" : "❌ ACCESS DENIED"}',
      name: 'PREMIUM',
    );

    if (isPremium || isFree) {
      action();
    } else {
      showDialog(context: context, builder: (_) => const PremiumUnlockDialog());
    }
  }

  Widget _buildDynamicCourseBlock(
    BuildContext context,
    DashboardSection section,
    GlobalKey? showcaseKey,
    String module,
    String titlePrefix,
    String titleAccent,
  ) {
    final widget = _buildPopularSection(
      context,
      section,
      titlePrefix,
      titleAccent,
    );
    final block = showcaseKey != null
        ? _buildShowcase(
            key: showcaseKey,
            title: 'Section Highlight',
            description: 'Explore dynamic content from ${section.title}',
            child: widget,
          )
        : widget;

    return ModuleVisibility(module: module, child: block);
  }

  Widget _buildPopularSection(
    BuildContext context,
    DashboardSection section,
    String titlePrefix,
    String titleAccent,
  ) {
    final theme = Theme.of(context);
    final courses = section.data.cast<CourseModel>();
    if (courses.isEmpty) return const SizedBox();

    final key = section.key.toLowerCase();

    // Branding Mapping
    CustomPainter painter = PopularCertPainter(); // Default
    Color accentColor = const Color(0xFF1E5FFF);
    List<Color> bgGradients = [
      const Color(0xFF030E30),
      const Color(0xFF1040C1),
    ];

    if (key.contains('certified') || key.contains('certification')) {
      painter = PopularCertPainter();
      accentColor = const Color(0xFFFF8800);
      bgGradients = [const Color(0xFF442200), const Color(0xFF994400)];
    } else if (key.contains('forex') || key.contains('finance')) {
      painter = PopularFinancePainter();
      accentColor = const Color(0xFFC8151B);
      bgGradients = [const Color(0xFF440000), const Color(0xFF6B0000)];
    } else if (key.contains('logistics')) {
      painter = PopularLogisticsPainter();
      accentColor = const Color(0xFF1E5FFF);
      bgGradients = [const Color(0xFF030E30), const Color(0xFF1040C1)];
    } else if (key.contains('market') || key.contains('sourcing')) {
      painter = PopularMarketPainter();
      accentColor = const Color(0xFF00C853);
      bgGradients = [const Color(0xFF003811), const Color(0xFF004D1A)];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(text: titlePrefix),
                    TextSpan(
                      text: titleAccent,
                      style: TextStyle(color: const Color(0xFFFFD000)),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => _handlePremiumGatedTap(
                  context: context,
                  sectionName:
                      'Course Section View All: $titlePrefix$titleAccent',
                  action: () =>
                      AppNavigator.push(context, const CoursesListScreen()),
                ),
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: List.generate(courses.length, (index) {
              final course = courses[index];
              return PopularCourseCard(
                rank: "#${index + 1}",
                title: course.title,
                category: section.title.split(' ').first,
                meta:
                    "${course.learnersCount ?? 1200}+ Learners · ${course.rating ?? 4.8} ★",
                price: course.basePrice.toStringAsFixed(0),
                iconPainter: painter,
                categoryColor: accentColor,
                iconBgColors: bgGradients,
                onTap: () {
                  developer.log(
                    '📂 Navigation -> Popular Course: ${course.title}',
                    name: 'NAVIGATION',
                  );
                  AppNavigator.push(
                    context,
                    CourseDetailsScreen(courseId: course.id),
                  );
                },
              );
            }),
          ),
        ),
        SizedBox(height: 0.8.h),
      ],
    );
  }
}

class _NavigationConfig {
  final List<BottomNavigationBarItem> items;
  final List<VoidCallback?> actions;
  final List<DashboardNavItem> schema;

  _NavigationConfig({
    required this.items,
    required this.actions,
    required this.schema,
  });
}
