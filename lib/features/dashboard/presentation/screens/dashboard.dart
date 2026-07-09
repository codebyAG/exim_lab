import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:exim_lab/common/widgets/promo_banner_dialog.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:exim_lab/localization/app_localization.dart';

import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';
import 'package:exim_lab/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:exim_lab/features/dashboard/presentation/providers/exchange_rate_provider.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/dashboard_home_view.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/premium_unlock_dialog.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/interest_dialog.dart';

import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:exim_lab/features/shorts/presentation/providers/shorts_provider.dart';
import 'package:exim_lab/features/module_manager/presentation/providers/module_provider.dart';

import 'package:exim_lab/features/chatai/presentation/screens/ai_chat_screen.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_list_screen.dart';
import 'package:exim_lab/features/news/presentation/screens/news_list_screen.dart';
import 'package:exim_lab/features/chat/presentation/screens/community_chat_screen.dart';
import 'package:exim_lab/features/shorts/presentation/screens/shorts_feed_screen.dart';
import 'package:exim_lab/features/profile/presentation/screens/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      context.read<AnalyticsService>().logEvent('home_view');

      final moduleProvider = context.read<ModuleProvider>();
      final dashboardProvider = context.read<DashboardProvider>();

      await Future.wait([
        moduleProvider.fetchModules(),
        dashboardProvider.fetchDashboardData(),
        dashboardProvider.initOnboardingState(),
        context.read<ExchangeRateProvider>().fetchRates(),
        context.read<NotificationsProvider>().fetchUnreadCount(),
        context.read<AuthProvider>().refreshMembershipStatus(),
      ]);

      if (!mounted) return;
      if (moduleProvider.isEnabled('shortVideos')) {
        context.read<ShortsProvider>().fetchShorts();
      }

      if (mounted) _handlePostLoadActions();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

    switch (nextAction) {
      case DashboardOnboardingAction.startTour:
        // Interactive tour removed with the redesigned dashboard — mark it as
        // seen and move on to the next onboarding step.
        dashboardProvider.markTourAsSeen();
        _handlePostLoadActions();
        break;
      case DashboardOnboardingAction.showInterestDialog:
        _showInterestDialog();
        break;
      case DashboardOnboardingAction.showPromoBanner:
        _triggerPromoBanner();
        break;
      case DashboardOnboardingAction.none:
        break;
    }
  }

  void _showInterestDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const InterestCaptureDialog(),
    ).then((_) {
      if (mounted) {
        context.read<DashboardProvider>().markInterestDialogAsShown();
        _handlePostLoadActions();
      }
    });
  }

  Future<void> _triggerPromoBanner() async {
    await Future.delayed(const Duration(seconds: 15));
    if (!mounted) return;
    final data = context.read<DashboardProvider>().data;
    if (data?.addons.popup != null) {
      _showPromoBanner(data!.addons.popup!);
    }
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
      builder: (_) => PromoBannerDialog(imageUrl: imgUrl, link: popup.ctaUrl),
    );
  }

  void _handleNavigationTap(int index, _NavigationConfig navConfig) {
    final item = navConfig.schema[index];

    // Premium gate for the community tab
    if (item.identifier == 'community') {
      final isPremium = context.read<AuthProvider>().user?.isPremium ?? false;
      if (!isPremium) {
        showDialog(
          context: context,
          builder: (_) => const PremiumUnlockDialog(),
        );
        return;
      }
    }

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutQuart,
    );
  }

  void _handlePremiumGatedTap({
    required BuildContext context,
    required VoidCallback action,
    required String sectionName,
    bool isFree = false,
  }) {
    final isPremium = context.read<AuthProvider>().user?.isPremium ?? false;
    if (isPremium || isFree) {
      action();
    } else {
      showDialog(context: context, builder: (_) => const PremiumUnlockDialog());
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final moduleProvider = Provider.of<ModuleProvider>(context);

    final navConfig = _buildNavigationConfig(context, t, moduleProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: navConfig.schema.map((item) {
          switch (item.identifier) {
            case 'home':
              return const DashboardHomeView();
            case 'shorts':
              return const ShortsFeedScreen(showBackButton: false);
            case 'courses':
              return const CoursesListScreen();
            case 'news':
              return const NewsListScreen(showBackButton: false);
            case 'community':
              return const CommunityChatScreen(showBackButton: false);
            case 'profile':
              return const ProfileScreen(showBackButton: false);
            default:
              return const SizedBox();
          }
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: navConfig.items,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1E5FFF),
        unselectedItemColor: const Color(0xFF94A3B8),
        elevation: 12,
        onTap: (index) => _handleNavigationTap(index, navConfig),
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

    final List<BottomNavigationBarItem> navItems = [];
    for (var item in schema) {
      navItems.add(
        BottomNavigationBarItem(
          icon: Icon(item.icon),
          activeIcon: Icon(item.activeIcon),
          label: t.translate(item.labelKey),
        ),
      );
    }

    return _NavigationConfig(items: navItems, schema: schema);
  }
}

class _NavigationConfig {
  final List<BottomNavigationBarItem> items;
  final List<DashboardNavItem> schema;

  _NavigationConfig({required this.items, required this.schema});
}
