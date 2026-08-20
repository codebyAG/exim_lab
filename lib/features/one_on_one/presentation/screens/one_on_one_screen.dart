import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/core/functions/whatsapp_utils.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:exim_lab/core/utils/icon_mapper.dart';
import 'package:exim_lab/core/widgets/youtube_video_dialog.dart';
import 'package:exim_lab/features/one_on_one/data/models/one_on_one_config_model.dart';
import 'package:exim_lab/features/one_on_one/presentation/providers/one_on_one_provider.dart';

/// Light page, dark purple "elements/sections" floating on top — matches
/// the Premium page's palette exactly (both pulled from the same hero art:
/// assets/premium_bg_purple.png + premium_hero_container.png), gold as the
/// shared accent.
class _C {
  static const pageBgLight = Color(0xFFFFFFFF);
  static const pageBgTint = Color(0xFFEEF2F8); // dashboard's lightBg

  static const navyDeep = Color(0xFF200058); // solid dark card background
  static const navy = Color(0xFF5008A8); // bright purple accent

  static const cardBg = navy;
  static final cardBorder = const Color(0xFFFFD000).withValues(alpha: 0.18);

  static const gold = Color(0xFFFFD000);
  static const goldDeep = Color(0xFFCC9E00);
  static const ink = navyDeep;

  // Text sitting on light page background (outside dark cards).
  static const headingOnLight = navyDeep;

  // Text sitting inside dark purple cards.
  static const textPrimary = Color(0xFFFFFFFF);
  static const textMuted = Color(0xFF94A3B8); // dashboard's slate
  static const originalPrice = Color(0xFF64748B);
  static const checkGreen = Color(0xFF1BA672); // dashboard's success green

  // The "brighter purple gradient area" — bright → mid → dark, sampled from
  // the hero art (identical to the Premium page's pricing gradient).
  static const panelGradient = LinearGradient(
    colors: [Color(0xFF5008A8), Color(0xFF380888), Color(0xFF180050)],
    stops: [0, 0.55, 1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const pageBackground = LinearGradient(
    colors: [pageBgLight, pageBgTint],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

/// Decorative rotating icon-circle palette (pastel bg + saturated icon) —
/// identical rotation to the Premium page's, kept as decorative variety.
class _IconDuo {
  final Color bg;
  final Color fg;
  const _IconDuo(this.bg, this.fg);
}

const List<_IconDuo> _iconDuos = [
  _IconDuo(Color(0xFFEDE9FE), Color(0xFF7C3AED)),
  _IconDuo(Color(0xFFD1FAE5), Color(0xFF059669)),
  _IconDuo(Color(0xFFFFEDD5), Color(0xFFEA580C)),
  _IconDuo(Color(0xFFDBEAFE), Color(0xFF2563EB)),
  _IconDuo(Color(0xFFFCE7F3), Color(0xFFDB2777)),
  _IconDuo(Color(0xFFCCFBF1), Color(0xFF0D9488)),
];

class OneOnOneScreen extends StatefulWidget {
  final bool showBackButton;
  const OneOnOneScreen({super.key, this.showBackButton = true});

  @override
  State<OneOnOneScreen> createState() => _OneOnOneScreenState();
}

class _OneOnOneScreenState extends State<OneOnOneScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsService>().logOneOnOnePageView();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<OneOnOneProvider>().load();
    });
  }

  // Phase 3B: WhatsApp is the only CTA action — no in-app payment flow.
  // If ctaWhatsappNumber is empty, do nothing but show a "coming soon"
  // state instead of a dead tap.
  void _bookNow(BuildContext context, OneOnOnePricing pricing) {
    context.read<AnalyticsService>().logOneOnOneCtaClick();
    if (pricing.ctaWhatsappNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking opens soon — stay tuned!")),
      );
      return;
    }
    WhatsAppUtils.launch(
      number: pricing.ctaWhatsappNumber,
      message: pricing.ctaWhatsappMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OneOnOneProvider>();
    final config = provider.config;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: _C.pageBackground),
        // top: false — the hero image bleeds behind the status bar; the
        // top bar row applies its own SafeArea inside the hero Stack.
        child: SafeArea(
          top: false,
          child: config == null
              ? _buildPlaceholder(provider)
              : RefreshIndicator(
                  color: _C.gold,
                  backgroundColor: _C.cardBg,
                  onRefresh: () =>
                      context.read<OneOnOneProvider>().load(force: true),
                  child: _buildContent(context, config),
                ),
        ),
      ),
    );
  }

  // Back button + PREMIUM badge — floats directly over the hero image (not
  // on a separate white strip above it).
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.showBackButton)
            InkWell(
              onTap: () => Navigator.maybePop(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _C.cardBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: _C.cardBorder),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: _C.gold,
                  size: 20,
                ),
              ),
            )
          else
            const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_C.gold, _C.goldDeep],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _C.gold.withValues(alpha: 0.45),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.workspace_premium_rounded,
                  color: _C.ink,
                  size: 15,
                ),
                const SizedBox(width: 5),
                Text(
                  "PREMIUM",
                  style: TextStyle(
                    color: _C.ink,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(OneOnOneProvider provider) {
    // Also covers the first frame, before initState's deferred load() call
    // has actually fired — isLoading is still false then, but there's no
    // error yet either, so it isn't the "couldn't load" case.
    if (provider.isLoading || provider.error == null) {
      return const Center(child: CircularProgressIndicator(color: _C.gold));
    }
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: _C.navy, size: 44),
            SizedBox(height: 2.h),
            Text(
              "Couldn't load session details",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _C.headingOnLight,
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.gold,
                foregroundColor: _C.ink,
              ),
              onPressed: () =>
                  context.read<OneOnOneProvider>().load(force: true),
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, OneOnOneConfig config) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            _buildHeroStack(config),
            if (config.benefits.isNotEmpty)
              Positioned(
                left: 5.w,
                right: 5.w,
                bottom: -30,
                child: _buildBenefitsRow(config.benefits),
              ),
          ],
        ),
        SizedBox(height: config.benefits.isNotEmpty ? 4.8.h : 1.5.h),
        Padding(
          padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 1.4.h),
          child: Column(
            children: [
              if (config.heroVideo != null) _buildHeroVideo(config.heroVideo!),

              if (config.journeySteps.isNotEmpty) ...[
                SizedBox(height: 1.8.h),
                const _FancyDivider(),
                SizedBox(height: 1.6.h),
                const _SectionTitle("YOUR JOURNEY"),
                SizedBox(height: 0.9.h),
                _buildJourneySteps(config.journeySteps),
              ],

              if (config.uniquePoints.isNotEmpty) ...[
                SizedBox(height: 1.8.h),
                const _FancyDivider(),
                SizedBox(height: 1.6.h),
                const _SectionTitle("WHY 1-ON-1 IS UNIQUE"),
                SizedBox(height: 0.9.h),
                _buildUniqueGrid(config.uniquePoints),
              ],

              if (config.highlightBanner != null) ...[
                SizedBox(height: 1.8.h),
                const _FancyDivider(),
                SizedBox(height: 1.6.h),
                _buildHighlightBanner(config.highlightBanner!),
              ],

              if (config.experienceVideos.isNotEmpty) ...[
                SizedBox(height: 1.8.h),
                const _FancyDivider(),
                SizedBox(height: 1.6.h),
                const _SectionTitle("REAL EXPERIENCES"),
                SizedBox(height: 0.9.h),
                _buildVideos(config.experienceVideos),
              ],

              if (config.trustBadges.isNotEmpty) ...[
                SizedBox(height: 1.8.h),
                const _FancyDivider(),
                SizedBox(height: 1.6.h),
                const _SectionTitle("WHY LEARNERS TRUST US"),
                SizedBox(height: 0.9.h),
                _buildTrustBadges(config.trustBadges),
              ],

              if (config.pricing != null) ...[
                SizedBox(height: 1.8.h),
                const _FancyDivider(),
                SizedBox(height: 1.6.h),
                _buildPricingCard(context, config.pricing!),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // Back button, PREMIUM badge, heading and subtitle all overlaid directly
  // on the hero image — one continuous background, no scrim needed since
  // the illustration's own light sky area keeps the dark text readable.
  // The benefits row (see _buildBenefitsRow) floats over its bottom edge.
  Widget _buildHeroStack(OneOnOneConfig config) {
    final hero = config.heroVideo;
    return GestureDetector(
      onTap: (hero == null || hero.videoUrl.isEmpty)
          ? null
          : () => showYoutubeVideoDialog(context, hero.videoUrl),
      child: SizedBox(
        width: double.infinity,
        height: 58.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const _HeroFallback(),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _buildTopBar(),
                  SizedBox(height: 0.6.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: _buildHeroText(config),
                  ),
                ],
              ),
            ),
            if (hero != null && hero.videoUrl.isNotEmpty)
              const Center(child: _PlayBadge(size: 58, iconSize: 30)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroText(OneOnOneConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          config.heading,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _C.headingOnLight,
            fontSize: 20.sp,
            height: 1.2,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (config.subheading.isNotEmpty) ...[
          SizedBox(height: 0.7.h),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _C.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _C.cardBorder),
            ),
            child: Text(
              config.subheading,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _C.gold,
                fontSize: 13.sp,
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeroVideo(OneOnOneHeroVideo hero) {
    return Column(
      children: [
        if (hero.videoUrl.isNotEmpty && hero.ctaText.isNotEmpty) ...[
          GestureDetector(
            onTap: () => showYoutubeVideoDialog(context, hero.videoUrl),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.6.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_C.gold, _C.goldDeep],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      hero.ctaText,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _C.ink,
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.play_circle_fill_rounded,
                    color: _C.ink,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ----------------------------------------------------------- BENEFITS ROW
  // Light floating card that pokes up over the hero image's bottom edge —
  // one row, pastel icon circles, dark labels (matches the reference).
  Widget _buildBenefitsRow(List<OneOnOneItem> items) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _C.navyDeep.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _iconDuos[i % _iconDuos.length].bg,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: FaIcon(
                        IconMapper.resolve(items[i].icon, fallbackIndex: i),
                        color: _iconDuos[i % _iconDuos.length].fg,
                        size: 17,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    items[i].title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _C.headingOnLight,
                      fontSize: 10.sp,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ------------------------------------------------------ UNIQUE POINT GRID
  // Individual "premium" cards (not one shared grid panel) — gold gradient
  // icon badge, title + description, gradient panel background matching
  // the journey/banner/pricing cards, so this section reads as a step up
  // rather than the same plain icon+label grid used elsewhere.
  Widget _buildUniqueGrid(List<OneOnOneItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.05,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (_, i) {
        final item = items[i];
        return Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            gradient: _C.panelGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _C.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_C.gold, _C.goldDeep],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FaIcon(
                    IconMapper.resolve(item.icon, fallbackIndex: i),
                    color: _C.ink,
                    size: 21,
                  ),
                ),
              ),
              const SizedBox(height: 9),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _C.textPrimary,
                  fontSize: 15.sp,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (item.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _C.textMuted,
                    fontSize: 12.sp,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------- JOURNEY
  // Premium vertical timeline — a gold gradient number badge per step,
  // connected by a fading gold line, each step's copy sitting on its own
  // purple gradient panel (matches the pricing/banner "premium" cards).
  Widget _buildJourneySteps(List<OneOnOneItem> steps) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_C.gold, _C.goldDeep],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _C.gold.withValues(alpha: 0.45),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '0${i + 1}',
                          style: const TextStyle(
                            color: _C.ink,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    if (i != steps.length - 1)
                      Expanded(
                        child: Container(
                          width: 2.5,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _C.gold.withValues(alpha: 0.6),
                                _C.gold.withValues(alpha: 0.08),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: i == steps.length - 1 ? 0 : 12,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: _C.panelGradient,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _C.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            steps[i].title,
                            style: TextStyle(
                              color: _C.textPrimary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (steps[i].description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              steps[i].description,
                              style: TextStyle(
                                color: _C.textMuted,
                                fontSize: 11.5.sp,
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // --------------------------------------------------------------- BANNER
  Widget _buildHighlightBanner(OneOnOneHighlightBanner banner) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: _C.panelGradient,
        border: Border.all(color: _C.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (banner.heading.isNotEmpty)
            Text(
              banner.heading,
              style: TextStyle(
                color: _C.textPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          if (banner.subheading.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              banner.subheading,
              style: TextStyle(
                color: _C.gold,
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          if (banner.items.isNotEmpty) ...[
            SizedBox(height: 1.4.h),
            Row(
              children: [
                for (var i = 0; i < banner.items.length; i++)
                  Expanded(
                    child: Column(
                      children: [
                        FaIcon(
                          IconMapper.resolve(
                            banner.items[i].icon,
                            fallbackIndex: i,
                          ),
                          color: _C.gold,
                          size: 20,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          banner.items[i].label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _C.textPrimary,
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // -------------------------------------------------------------- VIDEOS
  Widget _buildVideos(List<OneOnOneVideo> videos) {
    return Row(
      children: [
        for (var i = 0; i < videos.length && i < 2; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(child: _VideoTile(item: videos[i])),
        ],
      ],
    );
  }

  // --------------------------------------------------------- TRUST BADGES
  // One checklist card (not a grid of chips) — green check-in-circle rows
  // separated by hairline dividers, matching the journey timeline's card
  // language for a more premium, list-like read.
  Widget _buildTrustBadges(List<OneOnOneItem> badges) {
    return Container(
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _C.cardBorder),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          for (var i = 0; i < badges.length; i++) ...[
            if (i > 0) Divider(height: 1, color: _C.cardBorder),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 11,
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _C.checkGreen.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: _C.checkGreen,
                      size: 17,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      badges[i].label,
                      style: TextStyle(
                        color: _C.textPrimary,
                        fontSize: 13.sp,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ------------------------------------------------------------- PRICING
  // Two-tier "ticket" card — a gradient header band (heading + urgency
  // chip) on top, a solid navy price panel below with a green savings
  // pill and the CTA, separated by a notched dashed divider.
  Widget _buildPricingCard(BuildContext context, OneOnOnePricing pricing) {
    final urgency = pricing.effectiveUrgencyText;
    final savings = pricing.savingsLabel;
    return Container(
      decoration: BoxDecoration(
        color: _C.navyDeep,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _C.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            decoration: BoxDecoration(
              gradient: _C.panelGradient,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_C.gold, _C.goldDeep],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.handshake_rounded,
                    color: _C.ink,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pricing.heading,
                        style: TextStyle(
                          color: _C.textPrimary,
                          fontSize: 15.5.sp,
                          height: 1.2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (pricing.description.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          pricing.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _C.textMuted,
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (urgency.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: _C.navyDeep,
              child: Row(
                children: [
                  const Icon(
                    Icons.bolt_rounded,
                    color: _C.gold,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      urgency,
                      style: TextStyle(
                        color: _C.gold,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pricing.priceNote.isNotEmpty) ...[
                  Text(
                    pricing.priceNote,
                    style: TextStyle(
                      color: _C.textMuted,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        pricing.discountedPrice,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _C.gold,
                          fontSize: 30.sp,
                          height: 1,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    if (pricing.originalPrice.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          pricing.originalPrice,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _C.originalPrice,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: _C.originalPrice,
                          ),
                        ),
                      ),
                    ],
                    if (savings != null) ...[
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _C.checkGreen.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            savings,
                            style: TextStyle(
                              color: _C.checkGreen,
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 1.4.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: _C.gold.withValues(alpha: 0.5),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.gold,
                      foregroundColor: _C.ink,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 1.4.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => _bookNow(context, pricing),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            pricing.ctaText,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
                if (pricing.disclaimerText.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      pricing.disclaimerText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _C.textMuted,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: _C.headingOnLight,
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.8,
      ),
    );
  }
}

// Gold-diamond divider between major sections — a fading hairline on each
// side with a small rotated square at the center.
class _FancyDivider extends StatelessWidget {
  const _FancyDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, _C.cardBorder],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Transform.rotate(
            angle: 0.785398, // 45°
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_C.gold, _C.goldDeep],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_C.cardBorder, Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlayBadge extends StatelessWidget {
  final double size;
  final double iconSize;
  const _PlayBadge({required this.size, required this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(Icons.play_arrow_rounded, color: _C.ink, size: iconSize),
    );
  }
}

/// Shown whenever the admin hasn't set a video/experience thumbnail — the
/// bundled handshake hero art instead of a plain gradient block.
class _HeroFallback extends StatelessWidget {
  const _HeroFallback();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/one_on_one_hero.png', fit: BoxFit.cover);
  }
}

class _VideoTile extends StatelessWidget {
  final OneOnOneVideo item;
  const _VideoTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.videoUrl.isEmpty
          ? null
          : () => showYoutubeVideoDialog(context, item.videoUrl),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (item.thumbnailUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: item.thumbnailUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => const _HeroFallback(),
                  placeholder: (_, _) => const _HeroFallback(),
                )
              else
                const _HeroFallback(),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black54],
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              const Center(child: _PlayBadge(size: 40, iconSize: 22)),
              if (item.title.isNotEmpty)
                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 8,
                  child: Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
