import 'dart:developer' as developer;
import 'package:exim_lab/common/widgets/promo_banner_dialog.dart';
import 'package:exim_lab/features/dashboard/presentation/painters/dashboard_icons_painter.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/premium_short_video_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/skill_card.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/certificate_mini_card.dart';
import 'package:exim_lab/features/dashboard/presentation/providers/exchange_rate_provider.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/exchange_rate_ticker.dart';
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
import 'package:exim_lab/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/gallery/presentation/screens/gallery_screen.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/animated_search_bar.dart';
import 'package:exim_lab/features/courses/presentation/screens/course_search_delegate.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_details_screen.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_list_screen.dart';
import 'package:exim_lab/features/freevideos/presentation/screens/free_videos_details_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/export_price_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/import_calculator_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/hsn_finder_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/cbm_calculator.dart';
import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';
import 'package:exim_lab/features/quiz/presentation/screens/quiz_topics_screen.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/inline_banner.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/tool_section.dart';
import 'package:exim_lab/features/news/presentation/screens/news_list_screen.dart';
import 'package:exim_lab/features/chat/presentation/screens/community_chat_screen.dart';
import 'package:exim_lab/features/shorts/presentation/screens/shorts_feed_screen.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:exim_lab/features/profile/presentation/screens/profile_screen.dart';
import 'package:exim_lab/features/module_manager/presentation/widgets/module_visibility.dart';
import 'package:exim_lab/features/module_manager/presentation/providers/module_provider.dart';
import 'package:exim_lab/features/tools/presentation/screens/all_tools_screen.dart';
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
import 'package:exim_lab/features/dashboard/presentation/widgets/search_assistant_dialog.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:async';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final GlobalKey<_DashboardBodyState> _bodyKey;

  @override
  void initState() {
    super.initState();
    _bodyKey = GlobalKey<_DashboardBodyState>();
  }

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

  final GlobalKey _shortsKey = GlobalKey();

  final GlobalKey _quizzesCardKey = GlobalKey();
  final GlobalKey _aiExpertCardKey = GlobalKey();
  final GlobalKey _galleryCardKey = GlobalKey();

  final GlobalKey _continueKey = GlobalKey();
  final GlobalKey _toolsKey = GlobalKey();
  final GlobalKey _freeVideosKey = GlobalKey();
  final GlobalKey _pdfPromoKey = GlobalKey();

  final GlobalKey _navHomeKey = GlobalKey();
  final GlobalKey _navNewsKey = GlobalKey();
  final GlobalKey _navProfileKey = GlobalKey();

  final GlobalKey _popularCoursesKey = GlobalKey();

  Timer? _assistantTimer;
  bool _showAssistantPrompt = false;

  final ScrollController _scrollController = ScrollController();

  void _startAssistantTimer() {
    // 🛡️ Fix for warning: ensure we don't start multiple timers
    _assistantTimer?.cancel();

    // Show randomly between 30 to 120 seconds
    final randomSeconds = 30 + (DateTime.now().second % 60);
    _assistantTimer = Timer(Duration(seconds: randomSeconds), () {
      if (mounted) {
        setState(() => _showAssistantPrompt = true);

        // Auto hide after 12 seconds
        Timer(const Duration(seconds: 12), () {
          if (mounted) {
            setState(() => _showAssistantPrompt = false);
            // 🔄 Reschedule for next random interaction
            _startAssistantTimer();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _assistantTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // 💡 Point 12: Start Proactive Assistant
    _startAssistantTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        context.read<AnalyticsService>().logEvent('home_view');
        final dashboardProvider = context.read<DashboardProvider>();

        final moduleProvider = context.read<ModuleProvider>();

        // Load onboarding state (tour status etc.) alongside data
        await Future.wait([
          moduleProvider.fetchModules(),
          dashboardProvider.fetchDashboardData(),
          dashboardProvider.initOnboardingState(),
          context.read<ExchangeRateProvider>().fetchRates(),
          context.read<NotificationsProvider>().fetchUnreadCount(),
          context.read<AuthProvider>().refreshMembershipStatus(),
        ]);

        if (moduleProvider.isEnabled('shortVideos')) {
          // ignore: use_build_context_synchronously
          context.read<ShortsProvider>().fetchShorts();
        }

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

    developer.log(
      '🕵️ Pre-Onboarding Diagnostic:\n'
      '   - Provider initialized: ${dashboardProvider.data != null}\n'
      '   - Tour Seen Flag: ${dashboardProvider.isTourSeen}\n'
      '   - Interests Shown Flag: ${dashboardProvider.isInterestDialogShown}\n'
      '   - Has No Interests check: $hasNoInterest',
      name: 'ONBOARDING',
    );

    final nextAction = dashboardProvider.getNextOnboardingAction(
      hasNoInterests: hasNoInterest,
    );

    developer.log(
      '🎬 Onboarding Action Calculated -> [$nextAction]',
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
    developer.log(
      '🚦 _startShowcase() invoked. Waiting for paint...',
      name: 'ONBOARDING',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Increased delay to ensure list items have performed their first paint on slower devices
      await Future.delayed(const Duration(milliseconds: 1000));

      if (!mounted) return;

      final moduleProvider = context.read<ModuleProvider>();
      final dashboardProvider = context.read<DashboardProvider>();

      final List<GlobalKey> showcaseList = [
        _headerKey, // 1. Welcome
        _galleryCardKey, // 2. Success Stories (Gallery)
      ];

      // 3. Free Videos
      if (dashboardProvider.freeVideoSection != null &&
          dashboardProvider.freeVideoSection!.data.isNotEmpty) {
        showcaseList.add(_freeVideosKey);
      }

      // 4. Shorts
      final shortsProvider = context.read<ShortsProvider>();
      if (moduleProvider.isEnabled('shortVideos') &&
          shortsProvider.shorts.isNotEmpty) {
        showcaseList.add(_shortsKey);
      }

      // 5. Continue Learning
      if (moduleProvider.isEnabled('continueLearning') &&
          dashboardProvider.continueCourses.isNotEmpty) {
        showcaseList.add(_continueKey);
      }

      // 6. Practical Tools
      if (moduleProvider.isEnabled('tools')) {
        showcaseList.add(_toolsKey);
      }

      // 7. Free PDF Guide
      showcaseList.add(_pdfPromoKey);

      // 8. Quizzes
      if (moduleProvider.isEnabled('quizzes')) {
        showcaseList.add(_quizzesCardKey);
      }

      // 9. AI Expert
      if (moduleProvider.isEnabled('aiChat')) {
        showcaseList.add(_aiExpertCardKey);
      }

      // 10. Popular Courses
      if (dashboardProvider.popularCourseSection != null) {
        showcaseList.add(_popularCoursesKey);
      }

      // 11. Navigation: Home
      showcaseList.add(_navHomeKey);

      // 12. Navigation: News
      if (moduleProvider.isEnabled('news')) {
        showcaseList.add(_navNewsKey);
      }

      // 13. Navigation: Profile
      showcaseList.add(_navProfileKey);

      final List<MapEntry<String, GlobalKey>> itemsWithContext = showcaseList
          .map((k) => MapEntry(k.toString(), k))
          .where((e) => e.value.currentContext != null)
          .toList();

      final List<GlobalKey> activeKeys = itemsWithContext
          .map((e) => e.value)
          .toList();

      developer.log(
        '🔍 Tour Keys Check:\n'
        '   - Found: ${activeKeys.length} / ${showcaseList.length}\n'
        '   - Missing: ${showcaseList.length - activeKeys.length}',
        name: 'ONBOARDING',
      );

      if (activeKeys.isNotEmpty && mounted) {
        developer.log('🚀 Starting ShowCase Tour...', name: 'ONBOARDING');
        ShowCaseWidget.of(context).startShowCase(activeKeys);
      } else {
        developer.log(
          '⚠️ No visible keys found for tour. Skipping onboarding logic for now (will retry on next load).',
          name: 'ONBOARDING',
        );
        // Removed recursion to avoid infinite loops if UI hasn't fully rendered.
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

    return Scaffold(
      backgroundColor: const Color(0xFF020C28),
      bottomNavigationBar: BottomNavigationBar(
        items: navConfig.items,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF030E30),
        selectedItemColor: const Color(0xFFFFD000),
        unselectedItemColor: Colors.white54,
        onTap: (index) {
          if (navConfig.actions[index] != null) {
            navConfig.actions[index]!();
          }
        },
      ),
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
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () =>
                context.read<DashboardProvider>().fetchDashboardData(),
            child: ListView(
              controller: _scrollController,
              cacheExtent: 3000,
              padding: EdgeInsets.zero,
              children: [
                // 💹 LIVE FOREX MARQUEE TICKER (In SafeArea to avoid status bar overlap)
                const SafeArea(bottom: false, child: ExchangeRateTicker()),

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
                          completedCourses:
                              auth.user?.stats?.completedCourses ?? 0,
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
                // 3. PREMIUM FEATURE CARDS SCROLL (Square Type)
                SizedBox(height: 0.8.h),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    final isPremium = auth.user?.isPremium ?? false;

                    return SingleChildScrollView(
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
                            child: PremiumFeatureCard(
                              title: t.translate('gallery'),
                              icon: Icons.photo_library_rounded,
                              painter: GalleryIconPainter(),
                              buttonLabel: "Success Stories",
                              themeColor: const Color(0xFF0D47A1),
                              onTap: () => AppNavigator.push(
                                context,
                                const GalleryScreen(),
                              ),
                            ),
                          ),
                          // 💬 COMMUNITY
                          PremiumFeatureCard(
                            title: t.translate('exclusive_community'),
                            icon: Icons.forum_rounded,
                            isLocked: !isPremium,
                            buttonLabel: t.translate('join_community_subtitle'),
                            themeColor: const Color(
                              0xFF00C853,
                            ), // Green for Community
                            onTap: () => _handlePremiumGatedTap(
                              context: context,
                              sectionName: 'Community Hub',
                              action: () => AppNavigator.push(
                                context,
                                const CommunityChatScreen(),
                              ),
                            ),
                          ),
                          // 📊 MARKET UPDATES
                          PremiumFeatureCard(
                            title: t.translate('market_updates'),
                            icon: Icons.trending_up_rounded,
                            painter: MarketUpdatesIconPainter(),
                            buttonLabel: "Live Trends >",
                            themeColor: const Color(0xFFD32F2F),
                            onTap: () => AppNavigator.push(
                              context,
                              const NewsListScreen(),
                            ),
                          ),
                          // 🚢 IMPORT JOURNEY
                          PremiumFeatureCard(
                            title: t.translate('start_import_journey'),
                            icon: Icons.directions_boat_rounded,
                            painter: ImportJourneyIconPainter(),
                            buttonLabel: "Continue >",
                            themeColor: const Color(0xFF001A3D),
                            onTap: () => AppNavigator.push(
                              context,
                              const ImportJourneyScreen(),
                            ),
                          ),
                          // ✈️ EXPORT JOURNEY
                          PremiumFeatureCard(
                            title: t.translate('start_export_journey'),
                            icon: Icons.airplanemode_active_rounded,
                            painter: ExportJourneyIconPainter(),
                            buttonLabel: "Start Learning >",
                            themeColor: const Color(0xFFC06014),
                            onTap: () => AppNavigator.push(
                              context,
                              const ExportJourneyScreen(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 2.h),

                // 🛠️ 4. BUSINESS TOOLS (REPLACED SKILLS)
                /*
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
            */
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                          children: [
                            const TextSpan(text: "Business "),
                            TextSpan(
                              text: "Tools",
                              style: TextStyle(color: const Color(0xFFFFD000)),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          developer.log(
                            '📂 Navigation -> Tools: See All',
                            name: 'NAVIGATION',
                          );
                          AppNavigator.push(context, const AllToolsScreen());
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 0.6.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF1E5FFF,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(
                                0xFF1E5FFF,
                              ).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            "See All →",
                            style: TextStyle(
                              color: const Color(0xFF1E5FFF),
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),

                // 🔥 TOOLS GRID
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
                        onTap: () => _handlePremiumGatedTap(
                          context: context,
                          sectionName: 'Tool: Export Price Calculator',
                          action: () => AppNavigator.push(
                            context,
                            const ExportPriceCalculatorScreen(),
                          ),
                        ),
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
                        onTap: () => _handlePremiumGatedTap(
                          context: context,
                          sectionName: 'Tool: Import Calculator',
                          action: () => AppNavigator.push(
                            context,
                            const ImportCalculatorScreen(),
                          ),
                        ),
                      ),
                      SkillCard(
                        title: "HSN Finder",
                        subtitle: "Codes · Classification",
                        badge: "TOOL",
                        gradientColors: const [
                          Color(0xFF003A70),
                          Color(0xFF005AAA),
                        ],
                        painter: HsnFinderPainter(),
                        onTap: () => _handlePremiumGatedTap(
                          context: context,
                          sectionName: 'Tool: HSN Finder',
                          action: () => AppNavigator.push(
                            context,
                            const HsnFinderScreen(),
                          ),
                        ),
                      ),
                      SkillCard(
                        title: "CBM Calculator",
                        subtitle: "Volume · Weight",
                        badge: "TOOL",
                        gradientColors: const [
                          Color(0xFF4A2800),
                          Color(0xFF7A4400),
                        ],
                        painter: CbmCalculatorPainter(),
                        onTap: () => _handlePremiumGatedTap(
                          context: context,
                          sectionName: 'Tool: CBM Calculator',
                          action: () => AppNavigator.push(
                            context,
                            const CbmCalculatorScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),

                // 🎮 7. QUIZ SECTION (Premium Banner)
                if (moduleProvider.isEnabled('quizzes'))
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: GestureDetector(
                      onTap: () => _handlePremiumGatedTap(
                        context: context,
                        sectionName: 'Dashboard: Quiz Banner',
                        action: () => AppNavigator.push(
                          context,
                          const QuizTopicsScreen(),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF030E30),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(
                              0xFF1E5FFF,
                            ).withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF1E5FFF,
                              ).withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF1E5FFF,
                                ).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.psychology_rounded,
                                color: const Color(0xFFFFD000),
                                size: 28.sp,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Test Your Knowledge",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Plus Jakarta Sans',
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    "Take daily quizzes and boost your trade skills!",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 2.w),
                            IconButton.filled(
                              onPressed: () => _handlePremiumGatedTap(
                                context: context,
                                sectionName: 'Dashboard: Quiz Banner Btn',
                                action: () => AppNavigator.push(
                                  context,
                                  const QuizTopicsScreen(),
                                ),
                              ),
                              icon: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 18,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFF1E5FFF),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                        onTap: () => _showCertificateGuidanceDialog(context),
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
                        onTap: () => _showCertificateGuidanceDialog(context),
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
                        onTap: () => _showCertificateGuidanceDialog(context),
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
                        onTap: () => _showCertificateGuidanceDialog(context),
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
                          _buildShowcase(
                            key: _freeVideosKey,
                            title: 'tut_free_videos_title',
                            description: 'tut_free_videos_desc',
                            child: Padding(
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
                          ),
                          SizedBox(height: 2.h),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(left: 5.w, bottom: 2.h),
                            child: Row(
                              children: freeVideoSection.data
                                  .whereType<FreeVideoModel>()
                                  .map((video) {
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
                                  })
                                  .toList(),
                            ),
                          ),
                        ],

                        // ⚡ 4.10 SHORT VIDEOS SECTION
                        ModuleVisibility(
                          module: 'shortVideos',
                          child: Consumer<ShortsProvider>(
                            builder: (context, shortsProvider, _) {
                              if (shortsProvider.shorts.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 1.5.h),
                                  _buildShowcase(
                                    key: _shortsKey,
                                    title: 'tut_shorts_title',
                                    description: 'tut_shorts_desc',
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.w,
                                      ),
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
                                                const TextSpan(
                                                  text: "⚡ Short ",
                                                ),
                                                TextSpan(
                                                  text: "Videos",
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFFFFD000,
                                                    ),
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
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFF1E5FFF,
                                                  ),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Text(
                                                "View All →",
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFF1E5FFF,
                                                  ),
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.only(
                                      left: 5.w,
                                      bottom: 2.h,
                                    ),
                                    child: Row(
                                      children: [
                                        for (
                                          int i = 0;
                                          i < shortsProvider.shorts.length;
                                          i++
                                        )
                                          Builder(
                                            builder: (context) {
                                              final short =
                                                  shortsProvider.shorts[i];

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
                                                    gradients[i %
                                                        gradients.length],
                                                onTap: () {
                                                  AppNavigator.push(
                                                    context,
                                                    ShortsFeedScreen(
                                                      initialIndex: i,
                                                    ),
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
                                  final isPremium =
                                      auth.user?.isPremium ?? false;
                                  final course =
                                      dashboard.continueCourses.first;
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
                                        CourseDetailsScreen(
                                          courseId: course.id,
                                        ),
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                  ),
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
                                            const TextSpan(
                                              text: "🛠️ Practical ",
                                            ),
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
                                        color: const Color(
                                          0xFF1E5FFF,
                                        ), // AI Blue
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
                        SizedBox(
                          height: 8.h,
                        ), // Padding for pinned navigation bar
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          // 🧠 Point 12: Random Search Assistant Prompt
          if (_showAssistantPrompt)
            Positioned(
              bottom: 12.h,
              right: 5.w,
              left: 5.w,
              child: FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: GestureDetector(
                  onTap: () {
                    setState(() => _showAssistantPrompt = false);
                    showDialog(
                      context: context,
                      builder: (_) => const SearchAssistantDialog(),
                    );
                    // Reschedule after search
                    _startAssistantTimer();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E5FFF),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E5FFF).withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            "What are you looking for today?",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "SEARCH",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  _NavigationConfig _buildNavigationConfig(
    BuildContext context,
    AppLocalizations t,
    ModuleProvider moduleProvider,
  ) {
    final dashboardProvider = context.read<DashboardProvider>();
    final authProvider = context.read<AuthProvider>();
    final schema = dashboardProvider.getNavigationSchema(
      moduleProvider,
      user: authProvider.user,
    );

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
        case 'community':
          navActions.add(
            () => AppNavigator.push(context, const CommunityChatScreen()),
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

  void _showCertificateGuidanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF030E30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Text("🏆 ", style: TextStyle(fontSize: 24)),
            const Text(
              "Earn Certification",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
        content: const Text(
          "Please explore courses or join our certified programs to earn this professional badge.",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Maybe Later",
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AppNavigator.push(context, const CoursesListScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E5FFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Explore Courses",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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
    final courses = section.data.whereType<CourseModel>().toList();
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
