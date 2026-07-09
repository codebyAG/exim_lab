import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:exim_lab/core/theme/app_colors.dart';
import 'package:exim_lab/core/navigation/app_navigator.dart';
import 'package:exim_lab/core/functions/whatsapp_utils.dart';
import 'package:exim_lab/core/providers/config_provider.dart';

import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:exim_lab/features/shorts/presentation/providers/shorts_provider.dart';
import 'package:exim_lab/features/notifications/presentation/providers/notifications_provider.dart';

import 'package:exim_lab/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_list_screen.dart';
import 'package:exim_lab/features/courses/presentation/screens/courses_details_screen.dart';
import 'package:exim_lab/features/courses/presentation/screens/course_search_delegate.dart';
import 'package:exim_lab/features/shorts/presentation/screens/shorts_feed_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/all_tools_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/export_price_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/gst_calculator.dart';
import 'package:exim_lab/features/tools/presentation/screens/incoterms_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/forex_converter_screen.dart';
import 'package:exim_lab/features/tools/presentation/screens/hsn_finder_screen.dart';
import 'package:exim_lab/features/gallery/presentation/screens/gallery_screen.dart';
import 'package:exim_lab/features/chat/presentation/screens/community_chat_screen.dart';
import 'package:exim_lab/features/journey/presentation/screens/import_journey_screen.dart';
import 'package:exim_lab/features/journey/presentation/screens/export_journey_screen.dart';
import 'package:exim_lab/features/quiz/presentation/screens/quiz_topics_screen.dart';
import 'package:exim_lab/features/news/presentation/screens/news_list_screen.dart';
import 'package:exim_lab/features/profile/presentation/screens/profile_screen.dart';
import 'package:exim_lab/features/courses/data/models/course_model.dart';
import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';
import 'package:exim_lab/features/freevideos/data/models/free_videos_model.dart';
import 'package:exim_lab/features/freevideos/presentation/screens/free_videos_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/exchange_rate_ticker.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/gallery_marquee.dart';
import 'package:exim_lab/features/dashboard/presentation/widgets/inline_banner.dart';

/// Clean, mockup-accurate dashboard home. Pure Flutter/Material widgets.
class DashboardHomeView extends StatelessWidget {
  const DashboardHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.navy,
      onRefresh: () => context.read<DashboardProvider>().fetchDashboardData(),
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          // ── NAVY TOP (app-bar area): greeting + masterclass + dots ──
          Container(
            color: AppColors.navyDark,
            child: Column(
              children: [
                const _Header(),
                SizedBox(height: 1.6.h),
                const _MasterclassCard(),
                SizedBox(height: 1.2.h),
                const _CarouselDots(),
                SizedBox(height: 2.4.h),
              ],
            ),
          ),
          // ── WHITE SHEET with rounded top corners ──
          Transform.translate(
            offset: const Offset(0, -22),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: EdgeInsets.only(top: 2.6.h),
              child: Column(
                children: [
                  const ExchangeRateTicker(),
                  SizedBox(height: 2.h),
                  const _LiveBanner(),
                  SizedBox(height: 2.2.h),
                  const _ContinueLearning(),
                  SizedBox(height: 2.2.h),
                  const _ProgressCard(),
                  SizedBox(height: 2.2.h),
                  const _TopTools(),
                  SizedBox(height: 2.2.h),
                  const _QuizBanner(),
                  SizedBox(height: 2.2.h),
                  const _ShortsForYou(),
                  SizedBox(height: 2.2.h),
                  const _QuickAccess(),
                  SizedBox(height: 2.2.h),
                  const _CertificatesRow(),
                  SizedBox(height: 2.2.h),
                  const _ExploreGrid(),
                  SizedBox(height: 2.2.h),
                  const GalleryMarquee(),
                  SizedBox(height: 2.2.h),
                  const _AboutCard(),
                  SizedBox(height: 2.2.h),
                  const _FreePdfCard(),
                  SizedBox(height: 2.2.h),
                  _CourseRow(
                    title: "Popular Courses",
                    selector: (d) => d.popularCourseSection,
                  ),
                  SizedBox(height: 2.2.h),
                  _CourseRow(
                    title: "Recommended for You",
                    selector: (d) => d.recommendedCourseSection,
                  ),
                  SizedBox(height: 2.2.h),
                  _CourseRow(
                    title: "All Courses",
                    selector: (d) => d.allCourseSection,
                  ),
                  SizedBox(height: 2.2.h),
                  const _FreeVideos(),
                  SizedBox(height: 2.2.h),
                  Consumer<DashboardProvider>(
                    builder: (context, d, _) => d.inlineBanners.isEmpty
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: InlineBanner(banners: d.inlineBanners),
                          ),
                  ),
                  SizedBox(height: 2.2.h),
                  const _SocialFooter(),
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Static 3-dot carousel indicator under the masterclass card.
class _CarouselDots extends StatelessWidget {
  const _CarouselDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = i == 0;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? AppColors.gold : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Shared small section header: bold title + blue "See All"
// ─────────────────────────────────────────────────────────────
class _SectionHead extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback? onTap;
  const _SectionHead(this.title, {this.actionLabel = "See All", this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Text(
                actionLabel,
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Navy header: "Hi, {name} 👋" + subtitle + search + bell(badge)
// ─────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final name = context
        .watch<AuthProvider>()
        .user
        ?.name
        ?.split(' ')
        .first;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        2.w,
        MediaQuery.of(context).padding.top + 1.2.h,
        3.w,
        1.4.h,
      ),
      decoration: const BoxDecoration(color: AppColors.navyDark),
      child: Row(
        children: [
          _circleIcon(
            Icons.menu_rounded,
            () => AppNavigator.push(context, const ProfileScreen()),
          ),
          SizedBox(width: 1.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, ${name ?? 'Explorer'} 👋",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  "Ready to build your Import Export Business?",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _circleIcon(
            Icons.search_rounded,
            () => showSearch(context: context, delegate: CourseSearchDelegate()),
          ),
          SizedBox(width: 2.w),
          Consumer<NotificationsProvider>(
            builder: (context, notif, _) => Stack(
              clipBehavior: Clip.none,
              children: [
                _circleIcon(
                  Icons.notifications_none_rounded,
                  () => AppNavigator.push(
                    context,
                    const NotificationsScreen(),
                  ),
                ),
                if (notif.unreadCount > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.navyDark, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '${notif.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.white, size: 26),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Premium masterclass card (dark navy, gold label, Watch Now)
// ─────────────────────────────────────────────────────────────
class _MasterclassCard extends StatelessWidget {
  const _MasterclassCard();

  void _watch(BuildContext context) {
    final config = context.read<ConfigProvider>();
    WhatsAppUtils.launch(
      number: config.effectiveLinks.masterclassWhatsappNumber,
      message: "Hi, I want to join the Premium Masterclass.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.blue.withValues(alpha: 0.4)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Ship / portrait accent on the right
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 34.w,
              child: Opacity(
                opacity: 0.9,
                child: Image.asset(
                  'assets/ashok_sir_image.png',
                  fit: BoxFit.cover,
                  errorBuilder: (c, u, e) => const SizedBox.shrink(),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.navy,
                      AppColors.navy.withValues(alpha: 0.6),
                      AppColors.navy.withValues(alpha: 0.0),
                    ],
                    stops: const [0.35, 0.6, 1.0],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 2.2.h, 4.w, 2.2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "PREMIUM MASTERCLASS",
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  SizedBox(
                    width: 52.w,
                    child: Text(
                      "Start Your Import Export Business from Zero",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "By Mr. Harsh Dhawan",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.8.h),
                  ElevatedButton(
                    onPressed: () => _watch(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.navy,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 1.2.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Watch Now",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.play_arrow_rounded, size: 20),
                      ],
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
}

// ─────────────────────────────────────────────────────────────
// LIVE session banner (white card, red accents, Join Live)
// ─────────────────────────────────────────────────────────────
class _LiveBanner extends StatelessWidget {
  const _LiveBanner();

  void _join(BuildContext context) {
    final config = context.read<ConfigProvider>();
    final webinar = config.effectiveLiveEvent.webinar;
    WhatsAppUtils.launch(
      number: config.effectiveLinks.liveWhatsappNumber,
      message: webinar.whatsappMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final webinar = context.watch<ConfigProvider>().effectiveLiveEvent.webinar;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        padding: EdgeInsets.all(3.5.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF1F1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.red.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        "LIVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  "LIVE Session Today",
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        webinar.title ?? "Export Documentation Made Easy",
                        style: TextStyle(
                          color: AppColors.navy,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 0.6.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: AppColors.slate,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${webinar.time} IST",
                            style: TextStyle(
                              color: AppColors.slateText,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _join(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sensors_rounded, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        "Join Live",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
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

// ─────────────────────────────────────────────────────────────
// Continue Learning card (thumbnail + title + progress)
// ─────────────────────────────────────────────────────────────
class _ContinueLearning extends StatelessWidget {
  const _ContinueLearning();

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        if (dashboard.continueCourses.isEmpty) return const SizedBox.shrink();
        final course = dashboard.continueCourses.first;
        final pct = course.completionPercentage ?? 0;

        return Column(
          children: [
            _SectionHead(
              "Continue Learning",
              onTap: () =>
                  AppNavigator.push(context, const CoursesListScreen()),
            ),
            SizedBox(height: 1.4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => AppNavigator.push(
                  context,
                  CourseDetailsScreen(courseId: course.id),
                ),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.slate.withValues(alpha: 0.25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _thumb(course.imageUrl),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.navy,
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: (pct / 100).clamp(0.0, 1.0),
                                minHeight: 7,
                                backgroundColor:
                                    AppColors.slate.withValues(alpha: 0.2),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.blue,
                                ),
                              ),
                            ),
                            SizedBox(height: 0.8.h),
                            Text(
                              "$pct% Completed",
                              style: TextStyle(
                                color: AppColors.slateText,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.slate,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _thumb(String? url) {
    return Container(
      width: 22.w,
      height: 22.w,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (url != null && url.isNotEmpty)
            CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              errorWidget: (c, u, e) => const SizedBox.shrink(),
            ),
          Center(
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: AppColors.navy,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Top Tools — white cards with tinted colored Material icons
// ─────────────────────────────────────────────────────────────
class _TopTools extends StatelessWidget {
  const _TopTools();

  @override
  Widget build(BuildContext context) {
    final tools = <_ToolItem>[
      _ToolItem("Price Calculator", Icons.calculate_outlined, AppColors.blue,
          const ExportPriceCalculatorScreen()),
      _ToolItem("GST Calculator", Icons.receipt_long_outlined,
          const Color(0xFFF57C00), const GstCalculatorScreen()),
      _ToolItem("Incoterms", Icons.hexagon_outlined, AppColors.green,
          const IncotermsScreen()),
      _ToolItem("Currency Rates", Icons.currency_exchange_rounded,
          const Color(0xFF7C4DFF), const ForexConverterScreen()),
      _ToolItem("HS Code Finder", Icons.widgets_outlined, AppColors.blue,
          const HsnFinderScreen()),
    ];

    return Column(
      children: [
        _SectionHead(
          "Top Tools",
          actionLabel: "View All",
          onTap: () => AppNavigator.push(context, const AllToolsScreen()),
        ),
        SizedBox(height: 1.4.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int index = 0; index < tools.length; index++) ...[
                if (index > 0) SizedBox(width: 3.w),
                _toolCard(context, tools[index]),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _toolCard(BuildContext context, _ToolItem tool) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => AppNavigator.push(context, tool.screen),
      child: Container(
        width: 24.w,
        padding: EdgeInsets.symmetric(vertical: 1.6.h, horizontal: 1.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.slate.withValues(alpha: 0.22)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: tool.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(tool.icon, color: tool.color, size: 24),
            ),
            SizedBox(height: 1.h),
            Text(
              tool.label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolItem {
  final String label;
  final IconData icon;
  final Color color;
  final Widget screen;
  _ToolItem(this.label, this.icon, this.color, this.screen);
}

// ─────────────────────────────────────────────────────────────
// Shorts For You — horizontal video thumbnails
// ─────────────────────────────────────────────────────────────
class _ShortsForYou extends StatelessWidget {
  const _ShortsForYou();

  String _fmtDuration(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return "$m:${sec.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShortsProvider>(
      builder: (context, provider, _) {
        if (provider.shorts.isEmpty) return const SizedBox.shrink();
        final shorts = provider.shorts;

        return Column(
          children: [
            _SectionHead(
              "Shorts For You",
              onTap: () =>
                  AppNavigator.push(context, const ShortsFeedScreen()),
            ),
            SizedBox(height: 1.4.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(shorts.length, (index) {
                  final short = shorts[index];
                  final vid =
                      YoutubePlayer.convertUrlToId(short.videoUrl);
                  final thumb = vid != null
                      ? 'https://img.youtube.com/vi/$vid/0.jpg'
                      : short.thumbnailUrl;

                  return Padding(
                    padding: EdgeInsets.only(right: 3.w),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => AppNavigator.push(
                        context,
                        ShortsFeedScreen(initialIndex: index),
                      ),
                      child: SizedBox(
                        width: 33.w,
                        child: AspectRatio(
                          aspectRatio: 9 / 15,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: AppColors.navyDark,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                        children: [
                          if (thumb.isNotEmpty)
                            CachedNetworkImage(
                              imageUrl: thumb,
                              fit: BoxFit.cover,
                              errorWidget: (c, u, e) =>
                                  const SizedBox.shrink(),
                            ),
                          // gradient for legibility
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black87],
                                stops: [0.4, 1.0],
                              ),
                            ),
                          ),
                          const Center(
                            child: Icon(
                              Icons.play_circle_fill_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _fmtDuration(
                                  short.durationSeconds > 0
                                      ? short.durationSeconds
                                      : 45,
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            right: 8,
                            bottom: 8,
                            child: Text(
                              short.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.15,
                              ),
                            ),
                          ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Quick Access — 4 tinted tiles
// ─────────────────────────────────────────────────────────────
class _QuickAccess extends StatelessWidget {
  const _QuickAccess();

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<AuthProvider>().user?.stats;
    final tiles = <_QuickItem>[
      _QuickItem(
        "My Courses",
        "${stats?.totalCourses ?? 0} Enrolled",
        Icons.menu_book_rounded,
        AppColors.blue,
        () => AppNavigator.push(context, const CoursesListScreen()),
      ),
      _QuickItem(
        "Certificates",
        "${stats?.completedCourses ?? 0} Earned",
        Icons.workspace_premium_rounded,
        AppColors.green,
        () => AppNavigator.push(context, const CoursesListScreen()),
      ),
      _QuickItem(
        "Wishlist",
        "Saved",
        Icons.star_rounded,
        AppColors.gold,
        () => AppNavigator.push(context, const CoursesListScreen()),
      ),
      _QuickItem(
        "Downloads",
        "Files",
        Icons.download_rounded,
        const Color(0xFF7C4DFF),
        () => AppNavigator.push(context, const CoursesListScreen()),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            "Quick Access",
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SizedBox(height: 1.4.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              for (int i = 0; i < tiles.length; i++) ...[
                Expanded(child: _tile(tiles[i])),
                if (i < tiles.length - 1) SizedBox(width: 2.5.w),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _tile(_QuickItem item) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.6.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: item.color.withValues(alpha: 0.18)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: item.color, size: 20),
            ),
            SizedBox(height: 0.8.h),
            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              item.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.slateText,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  _QuickItem(this.title, this.subtitle, this.icon, this.color, this.onTap);
}

// ─────────────────────────────────────────────────────────────
// Explore — feature tiles (Journey, Quizzes, Gallery, Community…)
// ─────────────────────────────────────────────────────────────
class _ExploreGrid extends StatelessWidget {
  const _ExploreGrid();

  @override
  Widget build(BuildContext context) {
    final items = <_QuickItem>[
      _QuickItem(
        "Import Journey",
        "Step-by-step",
        Icons.directions_boat_filled_rounded,
        AppColors.blue,
        () => AppNavigator.push(context, const ImportJourneyScreen()),
      ),
      _QuickItem(
        "Export Journey",
        "Start learning",
        Icons.flight_takeoff_rounded,
        const Color(0xFFF57C00),
        () => AppNavigator.push(context, const ExportJourneyScreen()),
      ),
      _QuickItem(
        "Quizzes",
        "Test skills",
        Icons.psychology_rounded,
        AppColors.green,
        () => AppNavigator.push(context, const QuizTopicsScreen()),
      ),
      _QuickItem(
        "Gallery",
        "Success stories",
        Icons.photo_library_rounded,
        const Color(0xFF7C4DFF),
        () => AppNavigator.push(context, const GalleryScreen()),
      ),
      _QuickItem(
        "Community",
        "Connect & grow",
        Icons.forum_rounded,
        AppColors.blue,
        () => AppNavigator.push(context, const CommunityChatScreen()),
      ),
      _QuickItem(
        "Market News",
        "Latest updates",
        Icons.trending_up_rounded,
        AppColors.red,
        () => AppNavigator.push(context, const NewsListScreen()),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            "Explore",
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SizedBox(height: 1.4.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 2.5.w,
              crossAxisSpacing: 2.5.w,
              childAspectRatio: 2.6,
            ),
            itemBuilder: (context, index) => _tile(items[index]),
          ),
        ),
      ],
    );
  }

  Widget _tile(_QuickItem item) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.slate.withValues(alpha: 0.22)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.color, size: 22),
            ),
            SizedBox(width: 2.5.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.slateText,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
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
}

// ─────────────────────────────────────────────────────────────
// Popular Courses — horizontal course cards
// ─────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────
// Free Videos — horizontal video cards
// ─────────────────────────────────────────────────────────────
class _FreeVideos extends StatelessWidget {
  const _FreeVideos();

  String _fmt(int s) => "${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        final videos = dashboard.freeVideoSection?.data
                .whereType<FreeVideoModel>()
                .toList() ??
            const <FreeVideoModel>[];
        if (videos.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            _SectionHead(
              "Free Videos",
              onTap: () =>
                  AppNavigator.push(context, const CoursesListScreen()),
            ),
            SizedBox(height: 1.4.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(videos.length, (index) {
                  final v = videos[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => AppNavigator.push(
                      context,
                      FreeVideoDetailsScreen(video: v),
                    ),
                    child: Container(
                      width: 44.w,
                      margin: EdgeInsets.only(right: 3.w),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.slate.withValues(alpha: 0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 10,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(
                                  color: AppColors.navy.withValues(alpha: 0.08),
                                  child: v.thumbnailUrl.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: v.thumbnailUrl,
                                          fit: BoxFit.cover,
                                          errorWidget: (c, u, e) => const Icon(
                                            Icons.play_circle_outline,
                                            color: AppColors.navy,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.play_circle_outline,
                                          color: AppColors.navy,
                                        ),
                                ),
                                const Center(
                                  child: Icon(
                                    Icons.play_circle_fill_rounded,
                                    color: Colors.white,
                                    size: 34,
                                  ),
                                ),
                                Positioned(
                                  bottom: 6,
                                  right: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      _fmt(v.durationSeconds),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(2.5.w),
                            child: Text(
                              v.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.navy,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Social footer — connect links (from config)
// ─────────────────────────────────────────────────────────────
class _SocialFooter extends StatelessWidget {
  const _SocialFooter();

  Future<void> _open(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final links = context.watch<ConfigProvider>().effectiveLinks;
    final items = <_SocialItem>[
      _SocialItem(
          Icons.play_circle_fill_rounded, const Color(0xFFFF0000), links.youtubeUrl),
      _SocialItem(
          Icons.camera_alt_rounded, const Color(0xFFE1306C), links.instagramUrl),
      _SocialItem(Icons.facebook_rounded, const Color(0xFF1877F2), links.facebookUrl),
      _SocialItem(Icons.language_rounded, AppColors.blue, links.websiteUrl),
    ].where((e) => e.url.isNotEmpty).toList();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            "Connect with us",
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 1.6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final s in items)
                InkWell(
                  onTap: () => _open(s.url),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 46,
                    height: 46,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.07),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(s.icon, color: s.color, size: 24),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.6.h),
          Text(
            links.supportEmail,
            style: TextStyle(
              color: AppColors.slateText,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialItem {
  final IconData icon;
  final Color color;
  final String url;
  _SocialItem(this.icon, this.color, this.url);
}

// ─────────────────────────────────────────────────────────────
// About SIIEA card
// ─────────────────────────────────────────────────────────────
class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.navy, AppColors.navyDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: 0.2),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.verified_rounded,
                    color: AppColors.gold, size: 20),
                SizedBox(width: 2.w),
                Text(
                  "About SIIEA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              "Startup India Import Export Academy — a leading Export-Import "
              "training center with 50+ years of expertise, trusted by 50K+ "
              "learners worldwide.",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 11.sp,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Your Progress card
// ─────────────────────────────────────────────────────────────
class _ProgressCard extends StatelessWidget {
  const _ProgressCard();

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<AuthProvider>().user?.stats;
    final total = stats?.totalCourses ?? 10;
    final done = stats?.completedCourses ?? 0;
    final pct = total > 0 ? (done / total).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.slate.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "📘 Your Progress",
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "${(pct * 100).toInt()}%",
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.4.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 9,
                backgroundColor: AppColors.slate.withValues(alpha: 0.18),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.blue),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              "$done of $total lessons complete",
              style: TextStyle(
                color: AppColors.slateText,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Quiz banner — "Test Your Knowledge"
// ─────────────────────────────────────────────────────────────
class _QuizBanner extends StatelessWidget {
  const _QuizBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => AppNavigator.push(context, const QuizTopicsScreen()),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.green.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.psychology_rounded,
                    color: AppColors.green, size: 26),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Test Your Knowledge",
                      style: TextStyle(
                        color: AppColors.navy,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 0.4.h),
                    Text(
                      "Take daily quizzes & boost your trade skills",
                      style: TextStyle(
                        color: AppColors.slateText,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: AppColors.green, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Certificates row
// ─────────────────────────────────────────────────────────────
class _CertificatesRow extends StatelessWidget {
  const _CertificatesRow();

  @override
  Widget build(BuildContext context) {
    final certs = <_CertItem>[
      _CertItem("Export", "Beginner", "🎯", AppColors.blue),
      _CertItem("Documentation", "Expert", "📋", AppColors.red),
      _CertItem("Trade", "Analyst", "⚔️", AppColors.navy),
      _CertItem("Advanced", "Pro", "🏆", AppColors.gold),
    ];

    return Column(
      children: [
        _SectionHead(
          "Certificates",
          onTap: () => AppNavigator.push(context, const CoursesListScreen()),
        ),
        SizedBox(height: 1.4.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              for (final c in certs)
                Container(
                  width: 30.w,
                  margin: EdgeInsets.only(right: 3.w),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: c.color.withValues(alpha: 0.25)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(c.emoji, style: const TextStyle(fontSize: 22)),
                      SizedBox(height: 1.h),
                      Text(
                        c.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.navy,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        c.level,
                        style: TextStyle(
                          color: c.color,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CertItem {
  final String title;
  final String level;
  final String emoji;
  final Color color;
  _CertItem(this.title, this.level, this.emoji, this.color);
}

// ─────────────────────────────────────────────────────────────
// Free PDF guide promo
// ─────────────────────────────────────────────────────────────
class _FreePdfCard extends StatelessWidget {
  const _FreePdfCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          final config = context.read<ConfigProvider>();
          WhatsAppUtils.launch(
            number: config.effectiveLinks.whatsappNumber,
            message: "Hi, I want the FREE Import-Export starter guide (PDF).",
          );
        },
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.picture_as_pdf_rounded,
                    color: Color(0xFFB8860B), size: 26),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Free Export Starter Guide",
                      style: TextStyle(
                        color: AppColors.navy,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 0.4.h),
                    Text(
                      "Download the complete PDF — free",
                      style: TextStyle(
                        color: AppColors.slateText,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.download_rounded,
                  color: Color(0xFFB8860B), size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseRow extends StatelessWidget {
  final String title;
  final DashboardSection? Function(DashboardProvider) selector;
  const _CourseRow({required this.title, required this.selector});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        final section = selector(dashboard);
        final courses =
            section?.data.whereType<CourseModel>().toList() ?? const [];
        if (courses.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            _SectionHead(
              title,
              onTap: () =>
                  AppNavigator.push(context, const CoursesListScreen()),
            ),
            SizedBox(height: 1.4.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(courses.length, (index) {
                  final course = courses[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => AppNavigator.push(
                      context,
                      CourseDetailsScreen(courseId: course.id),
                    ),
                    child: Container(
                      width: 44.w,
                      margin: EdgeInsets.only(right: 3.w),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.slate.withValues(alpha: 0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 10,
                            child: Container(
                              width: double.infinity,
                              color: AppColors.navy.withValues(alpha: 0.08),
                              child: (course.imageUrl != null &&
                                      course.imageUrl!.isNotEmpty)
                                  ? CachedNetworkImage(
                                      imageUrl: course.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorWidget: (c, u, e) => const Icon(
                                        Icons.menu_book_rounded,
                                        color: AppColors.navy,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.menu_book_rounded,
                                      color: AppColors.navy,
                                    ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(2.5.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.navy,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(height: 0.8.h),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: AppColors.gold,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      "${course.rating ?? 4.8}",
                                      style: TextStyle(
                                        color: AppColors.slateText,
                                        fontSize: 10.5.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      course.basePrice == 0
                                          ? "Free"
                                          : "₹${course.basePrice.toStringAsFixed(0)}",
                                      style: TextStyle(
                                        color: AppColors.blue,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}
