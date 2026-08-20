import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:exim_lab/core/utils/icon_mapper.dart';
import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/features/premium/data/models/premium_config_model.dart';
import 'package:exim_lab/features/premium/presentation/providers/premium_provider.dart';
import 'package:exim_lab/core/widgets/youtube_video_dialog.dart';

/// Light page, dark purple/violet "elements/sections" floating on top — the
/// app's own documented rule (see PROJECT_CONTEXT B1: "dark elements on
/// light background look good"). The purple is pulled from the hero art
/// itself (assets/premium_bg_purple.png + premium_hero_container.png) so the
/// whole page reads as one cohesive theme, gold stays as the accent (crown
/// and shield in that same hero art).
class _P {
  static const pageBgLight = Color(0xFFFFFFFF);
  static const pageBgTint = Color(0xFFEEF2F8); // dashboard's lightBg

  // Sampled directly from the hero art (premium_bg_purple.png).
  static const navyDeep = Color(0xFF200058); // solid dark card background
  static const navy = Color(0xFF5008A8); // bright purple accent

  static const cardBg = navy;
  static final cardBorder = const Color(0xFFFFD000).withValues(alpha: 0.18);

  static const gold = Color(0xFFFFD000); // dashboard's gold accent
  static const goldDeep = Color(0xFFCC9E00);
  static const ink = navyDeep;

  // Text sitting on light page background (outside dark cards).
  static const headingOnLight = navyDeep;
  static const textMutedOnLight = Color(0xFF64748B); // dashboard's slate

  // Text sitting inside dark navy cards.
  static const textPrimary = Color(0xFFFFFFFF);
  static const textMuted = Color(0xFF94A3B8); // dashboard's slate
  static const originalPrice = Color(0xFF64748B);
  static const checkGreen = Color(0xFF1BA672); // dashboard's success green

  // The "brighter purple gradient area" — bright → mid → dark, sampled from
  // the hero art.
  static const pricingGradient = LinearGradient(
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
/// unchanged by the dark re-skin, kept for feature/stat/benefit icons.
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

/// Premium features page.
///
/// Layout order is fixed in code; every piece of content comes from
/// GET /api/premium-features/config via [PremiumProvider]. Sections with no
/// data simply do not render.
class PremiumFeaturesScreen extends StatefulWidget {
  final bool showBackButton;
  const PremiumFeaturesScreen({super.key, this.showBackButton = true});

  @override
  State<PremiumFeaturesScreen> createState() => _PremiumFeaturesScreenState();
}

class _PremiumFeaturesScreenState extends State<PremiumFeaturesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<PremiumProvider>().load();
    });
  }

  // Phase 1: the CTA button renders but is not wired up yet — WhatsApp
  // launch + analytics logging land in Phase 3. Still give the tap visible
  // feedback so it doesn't look broken/unresponsive.
  void _contactSales(BuildContext context, PremiumConfig config) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Enrollment opens soon — stay tuned!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PremiumProvider>();
    final isPremium = context.select<AuthProvider, bool>(
      (a) => a.user?.isPremium ?? false,
    );
    final config = provider.config;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: _P.pageBackground),
        child: SafeArea(
          child: config == null
              ? _buildPlaceholder(provider)
              : RefreshIndicator(
                  color: _P.gold,
                  backgroundColor: _P.cardBg,
                  onRefresh: () =>
                      context.read<PremiumProvider>().load(force: true),
                  child: _buildContent(context, config, isPremium),
                ),
        ),
      ),
    );
  }

  // Back button + PREMIUM badge — sit directly on the page background, no
  // boxed panel behind them (matches the reference: one continuous
  // background runs behind the whole hero, not a separate colored strip).
  Widget _buildTopBar(bool isPremium) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.showBackButton)
            _TopBarCircleButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => Navigator.maybePop(context),
            )
          else
            const SizedBox(width: 12),
          _PremiumBadge(isMember: isPremium),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(PremiumProvider provider) {
    // Also covers the first frame, before initState's deferred load() call
    // has actually fired — isLoading is still false then, but there's no
    // error yet either, so it isn't the "couldn't load" case.
    if (provider.isLoading || provider.error == null) {
      return const Center(child: CircularProgressIndicator(color: _P.gold));
    }
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, color: _P.navy, size: 46),
            SizedBox(height: 2.h),
            Text(
              "Couldn't load premium details",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _P.headingOnLight,
                fontSize: 19.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _P.gold,
                foregroundColor: _P.ink,
              ),
              onPressed: () =>
                  context.read<PremiumProvider>().load(force: true),
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    PremiumConfig config,
    bool isPremium,
  ) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildTopBar(isPremium),
        // 1 + 2 — hero heading/subheading and hero visual
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: _buildHeroText(config),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(5.w, 1.4.h, 5.w, 2.h),
          child: Column(
            children: [
              _buildHeroArt(config),
              ..._bannerSlot(config, PremiumBannerSlot.afterHero),

              // 3 — stats
              if (config.stats.isNotEmpty) ...[
                SizedBox(height: 1.6.h),
                _buildStatsCard(config.stats),
              ],
              ..._bannerSlot(config, PremiumBannerSlot.afterStats),

              // 4 — feature grid
              if (config.features.isNotEmpty) ...[
                SizedBox(height: 2.h),
                const _FancyDivider(),
                SizedBox(height: 2.2.h),
                _SectionTitle(config.featuresHeading),
                SizedBox(height: 1.4.h),
                _buildBenefitsGrid(config.features, config.gridColumns),
              ],
              ..._bannerSlot(config, PremiumBannerSlot.afterFeatures),

              // 5 — instructors (vertical stack of 16:9 photo cards)
              if (config.instructors.isNotEmpty) ...[
                SizedBox(height: 2.h),
                const _FancyDivider(),
                SizedBox(height: 2.2.h),
                _SectionTitle(config.instructorsHeading),
                SizedBox(height: 1.4.h),
                _buildInstructors(config.instructors),
              ],

              // 6 — videos
              if (config.videos.isNotEmpty) ...[
                SizedBox(height: 2.h),
                const _FancyDivider(),
                SizedBox(height: 2.2.h),
                _SectionTitle(config.videosHeading),
                SizedBox(height: 1.4.h),
                _buildVideos(config.videos),
              ],
              ..._bannerSlot(config, PremiumBannerSlot.afterVideos),

              // 7 — testimonials
              if (config.testimonials.isNotEmpty) ...[
                SizedBox(height: 2.h),
                const _FancyDivider(),
                SizedBox(height: 2.2.h),
                _SectionTitle(config.testimonialsHeading),
                SizedBox(height: 1.4.h),
                _buildTestimonials(config.testimonials),
              ],
              ..._bannerSlot(config, PremiumBannerSlot.afterTestimonials),

              // 8 — pricing / CTA (always last)
              SizedBox(height: 2.h),
              const _FancyDivider(),
              SizedBox(height: 2.2.h),
              if (isPremium)
                _buildMemberCard()
              else if (config.pricing != null)
                _buildPricingCard(
                  context,
                  config,
                  config.pricing!,
                  config.ctaText,
                ),
            ],
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------- BANNERS
  // Equal 12px top/bottom margin, no color overlay on the image itself.
  List<Widget> _bannerSlot(PremiumConfig config, String position) {
    final slot = config.bannersAt(position);
    if (slot.isEmpty) return const [];
    return [
      for (final banner in slot)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: _BannerCard(banner: banner),
        ),
    ];
  }

  // ----------------------------------------------------------- HERO TEXT
  // Heading/subheading on the left, a small decorative graphic on the
  // right — matches the reference ("Go Premium" beside the crown/container
  // art), distinct from the real video block that follows below.
  Widget _buildHeroText(PremiumConfig config) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroHeading(config.heading),
              if (config.subheading.isNotEmpty) ...[
                SizedBox(height: 0.6.h),
                Text(
                  config.subheading,
                  style: TextStyle(
                    color: _P.textMutedOnLight,
                    fontSize: 12.5.sp,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 28.w,
          height: 28.w,
          child: Image.asset(
            'assets/premium_hero_container.png',
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  /// First word in the app's dark ink, the rest in violet — matches the
  /// reference ("Go" / "Premium") while staying safe for arbitrary admin
  /// heading text (falls back to a single-colour heading if there's no
  /// second word to split off).
  Widget _buildHeroHeading(String heading) {
    final firstSpace = heading.indexOf(' ');
    final baseStyle = TextStyle(
      fontSize: 22.sp,
      height: 1.15,
      fontWeight: FontWeight.w900,
      letterSpacing: 0.2,
    );
    if (firstSpace == -1) {
      return Text(heading, style: baseStyle.copyWith(color: _P.headingOnLight));
    }
    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(
            text: heading.substring(0, firstSpace),
            style: TextStyle(color: _P.headingOnLight),
          ),
          TextSpan(text: '\n'),
          TextSpan(
            text: heading.substring(firstSpace + 1),
            style: TextStyle(color: _P.navy),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroArt(PremiumConfig config) {
    final intro = config.introVideo;
    final heroImage = (intro?.thumbnailUrl.isNotEmpty ?? false)
        ? intro!.thumbnailUrl
        : config.bannerImageUrl;
    final videoUrl = intro?.videoUrl ?? '';
    final caption = config.bannerText;

    return GestureDetector(
      onTap: videoUrl.isEmpty
          ? null
          : () => showYoutubeVideoDialog(context, videoUrl),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AspectRatio(
          aspectRatio: 16 / 11,
          // Shows the real video's own thumbnail when the admin has set one;
          // only falls back to the decorative hero art when there's none.
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (heroImage.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: heroImage,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  errorWidget: (_, _, _) => const _HeroFallback(),
                  // Only genuine failures fall back to the decorative hero
                  // art — a plain loading tile while the real thumbnail
                  // fetches, so admins don't see the hero art flash/fade
                  // over their own configured thumbnail.
                  placeholder: (_, _) => const ColoredBox(color: _P.navyDeep),
                )
              else
                const _HeroFallback(),
              if (videoUrl.isNotEmpty)
                const Center(child: _PlayBadge(size: 62, iconSize: 34)),
              if (caption.isNotEmpty)
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: Text(
                    caption,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      shadows: const [
                        Shadow(color: Colors.black54, blurRadius: 6),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------- STATS
  Widget _buildStatsCard(List<PremiumStat> stats) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: _P.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _P.cardBorder),
      ),
      child: Row(
        children: List.generate(stats.length * 2 - 1, (j) {
          if (j.isOdd) {
            return Container(width: 1, height: 40, color: _P.cardBorder);
          }
          final i = j ~/ 2;
          final s = stats[i];
          final duo = _iconDuos[i % _iconDuos.length];
          return Expanded(
            child: Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: duo.bg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: FaIcon(
                      IconMapper.resolve(s.icon, fallbackIndex: i),
                      color: duo.fg,
                      size: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  child: Text(
                    s.value,
                    style: TextStyle(
                      color: _P.textPrimary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  s.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _P.textMuted,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ------------------------------------------------------------ FEATURES
  Widget _buildBenefitsGrid(List<PremiumFeatureItem> features, int columns) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (_, i) => _buildBenefitItem(features[i], i),
    );
  }

  Widget _buildBenefitItem(PremiumFeatureItem f, int i) {
    final duo = _iconDuos[i % _iconDuos.length];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _P.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _P.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: duo.bg, shape: BoxShape.circle),
            clipBehavior: Clip.antiAlias,
            child: f.imageUrl.isNotEmpty
                ? CachedNetworkImage(imageUrl: f.imageUrl, fit: BoxFit.cover)
                : Center(
                    child: FaIcon(
                      IconMapper.resolve(f.icon, fallbackIndex: i),
                      color: duo.fg,
                      size: 16,
                    ),
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  f.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _P.textPrimary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (f.description.isNotEmpty)
                  Text(
                    f.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _P.textMuted,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: _P.textMuted.withValues(alpha: 0.6),
            size: 18,
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------- INSTRUCTORS
  // Vertical stack of full-width 16:9 photo cards — no video, no play
  // button. imageUrl and name are each independently optional.
  Widget _buildInstructors(List<PremiumInstructor> instructors) {
    return Column(
      children: [
        for (var i = 0; i < instructors.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == instructors.length - 1 ? 0 : 1.2.h,
            ),
            child: _InstructorCard(instructor: instructors[i]),
          ),
      ],
    );
  }

  // -------------------------------------------------------------- VIDEOS
  Widget _buildVideos(List<PremiumVideo> videos) {
    final rest = videos.skip(1).toList();
    return Column(
      children: [
        _VideoTile(item: videos.first, large: true),
        if (rest.isNotEmpty) SizedBox(height: 1.2.h),
        for (var i = 0; i < rest.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: 1.2.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _VideoTile(item: rest[i])),
                const SizedBox(width: 12),
                Expanded(
                  child: i + 1 < rest.length
                      ? _VideoTile(item: rest[i + 1])
                      : const SizedBox(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // -------------------------------------------------------- TESTIMONIALS
  Widget _buildTestimonials(List<PremiumTestimonial> testimonials) {
    return Column(
      children: [
        for (final t in testimonials)
          Padding(
            padding: EdgeInsets.only(bottom: 1.2.h),
            child: _TestimonialCard(item: t),
          ),
      ],
    );
  }

  // ------------------------------------------------------------- PRICING
  // Two-tier "ticket" card — a gradient header band (heading + offer chip)
  // on top, a solid navy price panel below with checklist + CTA — same
  // language as the One-on-One page's pricing card.
  Widget _buildPricingCard(
    BuildContext context,
    PremiumConfig config,
    PremiumPricing pricing,
    String ctaText,
  ) {
    final savings = pricing.savingsLabel;
    return Container(
      decoration: BoxDecoration(
        color: _P.navyDeep,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _P.cardBorder),
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
              gradient: _P.pricingGradient,
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
                      colors: [_P.gold, _P.goldDeep],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: _P.ink,
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
                          color: _P.textPrimary,
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
                            color: _P.textMuted,
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
          if (pricing.offerBadgeText.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: _P.navyDeep,
              child: Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: _P.gold, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      pricing.offerBadgeText,
                      style: TextStyle(
                        color: _P.gold,
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
                      color: _P.textMuted,
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
                          color: _P.gold,
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
                            color: _P.originalPrice,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: _P.originalPrice,
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
                            color: _P.checkGreen.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            savings,
                            style: TextStyle(
                              color: _P.checkGreen,
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (pricing.benefits.isNotEmpty) ...[
                  SizedBox(height: 1.2.h),
                  Divider(color: _P.cardBorder, height: 1),
                  SizedBox(height: 1.2.h),
                  for (var i = 0; i < pricing.benefits.length; i += 2)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(child: _CheckLine(pricing.benefits[i])),
                          Expanded(
                            child: i + 1 < pricing.benefits.length
                                ? _CheckLine(pricing.benefits[i + 1])
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                ],
                SizedBox(height: 0.8.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: _P.gold.withValues(alpha: 0.5),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _P.gold,
                      foregroundColor: _P.ink,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => _contactSales(context, config),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            ctaText,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: _P.pricingGradient,
        border: Border.all(color: _P.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_P.gold, _P.goldDeep],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(color: _P.navyDeep, width: 3),
              boxShadow: [
                BoxShadow(
                  color: _P.gold.withValues(alpha: 0.45),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.verified_rounded, color: _P.ink, size: 34),
          ),
          const SizedBox(height: 12),
          Text(
            "You're a Premium Member",
            style: TextStyle(
              color: _P.textPrimary,
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _P.checkGreen.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "ACTIVE",
              style: TextStyle(
                color: _P.checkGreen,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Every feature above is already unlocked for you.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _P.textMuted,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBarCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _TopBarCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: _P.cardBg,
          shape: BoxShape.circle,
          border: Border.all(color: _P.cardBorder),
        ),
        child: const Icon(Icons.arrow_back_rounded, color: _P.gold, size: 20),
      ),
    );
  }
}

class _PremiumBadge extends StatelessWidget {
  final bool isMember;
  const _PremiumBadge({required this.isMember});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_P.gold, _P.goldDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _P.gold.withValues(alpha: 0.45),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium_rounded, color: _P.ink, size: 15),
          const SizedBox(width: 5),
          Text(
            isMember ? "PREMIUM MEMBER" : "PREMIUM",
            style: TextStyle(
              color: _P.ink,
              fontSize: 11.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 22, height: 2, color: _P.gold),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _P.headingOnLight,
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(width: 22, height: 2, color: _P.gold),
      ],
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
                colors: [Colors.transparent, _P.cardBorder],
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
                gradient: const LinearGradient(colors: [_P.gold, _P.goldDeep]),
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
                colors: [_P.cardBorder, Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CheckLine extends StatelessWidget {
  final String text;
  const _CheckLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_box_rounded, color: _P.checkGreen, size: 18),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _P.textPrimary,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w600,
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
      child: Icon(Icons.play_arrow_rounded, color: _P.ink, size: iconSize),
    );
  }
}

/// Shown whenever the admin hasn't set an intro-video thumbnail or banner
/// image — the bundled purple hero art instead of a plain gradient block.
class _HeroFallback extends StatelessWidget {
  const _HeroFallback();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/premium_bg_purple.png', fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Image.asset(
            'assets/premium_hero_container.png',
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

class _InstructorCard extends StatelessWidget {
  final PremiumInstructor instructor;
  const _InstructorCard({required this.instructor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _P.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _P.cardBorder),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: instructor.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: instructor.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => const _InstructorPlaceholder(),
                      placeholder: (_, _) => const _InstructorPlaceholder(),
                    )
                  : const _InstructorPlaceholder(),
            ),
          ),
          if (instructor.name.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              instructor.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _P.textPrimary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InstructorPlaceholder extends StatelessWidget {
  const _InstructorPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _P.navyDeep,
      child: Center(
        child: Icon(
          Icons.person_rounded,
          color: _P.textMuted.withValues(alpha: 0.5),
          size: 40,
        ),
      ),
    );
  }
}

class _VideoTile extends StatelessWidget {
  final PremiumVideo item;
  final bool large;
  const _VideoTile({required this.item, this.large = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.videoUrl.isEmpty
          ? null
          : () => showYoutubeVideoDialog(context, item.videoUrl),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: AspectRatio(
          aspectRatio: large ? 16 / 9 : 4 / 3,
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
                    colors: [Colors.transparent, Colors.black87],
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Center(
                child: _PlayBadge(
                  size: large ? 52 : 38,
                  iconSize: large ? 30 : 22,
                ),
              ),
              if (item.duration.isNotEmpty)
                Positioned(
                  top: 8,
                  right: 8,
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
                      item.duration,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              if (item.title.isNotEmpty)
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 8,
                  child: Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: large ? 11.sp : 9.5.sp,
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

class _TestimonialCard extends StatelessWidget {
  final PremiumTestimonial item;
  const _TestimonialCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _P.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _P.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < item.rating
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: _P.gold,
                size: 18,
              ),
            ),
          ),
          if (item.quote.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              item.quote,
              style: TextStyle(
                color: _P.textPrimary,
                fontSize: 15.sp,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: _P.navyDeep,
                backgroundImage: item.avatarUrl.isNotEmpty
                    ? CachedNetworkImageProvider(item.avatarUrl)
                    : null,
                child: item.avatarUrl.isEmpty
                    ? const Icon(Icons.person, color: _P.gold, size: 21)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    color: _P.textPrimary,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Full-color image, no tint. Caption renders as a dark chip; an optional
/// "Explore →" gold pill appears alongside it when `linkUrl` is set.
class _BannerCard extends StatelessWidget {
  final PremiumBanner banner;
  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        // Caps banner height so a very tall admin-uploaded image can't
        // blow out the page layout.
        aspectRatio: 16 / 7,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (banner.imageUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: banner.imageUrl,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => const _HeroFallback(),
              )
            else
              const _HeroFallback(),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Row(
                children: [
                  if (banner.text.isNotEmpty)
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF111827,
                          ).withValues(alpha: 0.72),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          banner.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  if (banner.text.isNotEmpty && banner.linkUrl.isNotEmpty)
                    const SizedBox(width: 8),
                  if (banner.linkUrl.isNotEmpty)
                    GestureDetector(
                      onTap: () => launchUrlString(
                        banner.linkUrl,
                        mode: LaunchMode.externalApplication,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _P.gold,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Explore →",
                          style: TextStyle(
                            color: _P.ink,
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w800,
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
}
