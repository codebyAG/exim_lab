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

/// Palette for this page only — a violet premium look that intentionally
/// differs from the app's navy/gold dashboard.
class _P {
  static const violet = Color(0xFF6C3FE0);
  static const violetDeep = Color(0xFF4B23B8);
  static const violetSoft = Color(0xFFF3EFFF);
  static const ink = Color(0xFF2A1B5E);
  static const body = Color(0xFF5B5480);
  static const gold = Color(0xFFFFC629);
}

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
      backgroundColor: _P.violetSoft,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (widget.showBackButton)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.arrow_back_rounded, color: _P.ink),
                ),
              ),
            Expanded(
              child: config == null
                  ? _buildPlaceholder(provider)
                  : RefreshIndicator(
                      onRefresh: () =>
                          context.read<PremiumProvider>().load(force: true),
                      child: _buildContent(context, config, isPremium),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(PremiumProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: _P.violet),
      );
    }
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: _P.violet, size: 46),
            SizedBox(height: 2.h),
            Text(
              "Couldn't load premium details",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _P.ink,
                fontSize: 16.5.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _P.violet,
                foregroundColor: Colors.white,
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
      padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 4.h),
      children: [
        // 1 + 2 — hero text and hero visual
        _buildHero(config, isPremium),
        ..._bannerSlot(config, PremiumBannerSlot.afterHero),

        // 3 — stats
        if (config.stats.isNotEmpty) ...[
          SizedBox(height: 2.h),
          _buildStatsCard(config.stats),
        ],
        ..._bannerSlot(config, PremiumBannerSlot.afterStats),

        // 4 — feature grid
        if (config.features.isNotEmpty) ...[
          SizedBox(height: 3.h),
          _SectionTitle(config.featuresHeading),
          SizedBox(height: 2.h),
          _buildBenefitsGrid(config.features, config.gridColumns),
        ],
        ..._bannerSlot(config, PremiumBannerSlot.afterFeatures),

        // 5 — instructors
        if (config.instructors.isNotEmpty) ...[
          SizedBox(height: 3.h),
          _SectionTitle(config.instructorsHeading),
          SizedBox(height: 2.h),
          _buildInstructors(config.instructors),
        ],

        // 6 — videos
        if (config.videos.isNotEmpty) ...[
          SizedBox(height: 3.h),
          _SectionTitle(config.videosHeading),
          SizedBox(height: 2.h),
          _buildVideos(config.videos),
        ],
        ..._bannerSlot(config, PremiumBannerSlot.afterVideos),

        // 7 — testimonials
        if (config.testimonials.isNotEmpty) ...[
          SizedBox(height: 3.h),
          _SectionTitle(config.testimonialsHeading),
          SizedBox(height: 2.h),
          _buildTestimonials(config.testimonials),
        ],
        ..._bannerSlot(config, PremiumBannerSlot.afterTestimonials),

        // 8 — pricing / CTA (always last)
        SizedBox(height: 3.h),
        if (isPremium)
          _buildMemberCard()
        else if (config.pricing != null)
          _buildPricingCard(context, config, config.pricing!, config.ctaText),
      ],
    );
  }

  // -------------------------------------------------------------- BANNERS
  List<Widget> _bannerSlot(PremiumConfig config, String position) {
    final slot = config.bannersAt(position);
    if (slot.isEmpty) return const [];
    return [
      for (final banner in slot) ...[
        SizedBox(height: 2.h),
        _BannerCard(banner: banner),
      ],
    ];
  }

  // ---------------------------------------------------------------- HERO
  Widget _buildHero(PremiumConfig config, bool isPremium) {
    final intro = config.introVideo;
    final heroImage = (intro?.thumbnailUrl.isNotEmpty ?? false)
        ? intro!.thumbnailUrl
        : config.bannerImageUrl;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _P.violet,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.workspace_premium_rounded,
                color: _P.gold,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                isPremium ? "PREMIUM MEMBER" : "PREMIUM",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          config.heading,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _P.violet,
            fontSize: 25.sp,
            height: 1.15,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        if (config.subheading.isNotEmpty) ...[
          SizedBox(height: 1.h),
          Text(
            config.subheading,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _P.body,
              fontSize: 15.5.sp,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        SizedBox(height: 2.h),
        _buildHeroArt(heroImage, intro?.videoUrl ?? '', config.bannerText),
      ],
    );
  }

  Widget _buildHeroArt(String imageUrl, String videoUrl, String caption) {
    return GestureDetector(
      onTap: videoUrl.isEmpty ? null : () => showYoutubeVideoDialog(context, videoUrl),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imageUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => const _HeroFallback(),
                  placeholder: (_, _) => const _HeroFallback(),
                )
              else
                const _HeroFallback(),
              if (videoUrl.isNotEmpty)
                Center(
                  child: Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: _P.violet,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _P.violet.withValues(alpha: 0.45),
                          blurRadius: 22,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 39,
                    ),
                  ),
                ),
              if (caption.isNotEmpty)
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      caption,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w800,
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

  // --------------------------------------------------------------- STATS
  Widget _buildStatsCard(List<PremiumStat> stats) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _P.violet.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: List.generate(stats.length, (i) {
          final s = stats[i];
          return Expanded(
                child: Column(
                  children: [
                    FaIcon(
                      IconMapper.resolve(s.icon, fallbackIndex: i),
                      color: _benefitColors[i % _benefitColors.length],
                      size: 16,
                    ),
                    const SizedBox(height: 6),
                    FittedBox(
                      child: Text(
                        s.value,
                        style: TextStyle(
                          color: _P.ink,
                          fontSize: 15.5.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Text(
                      s.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _P.body,
                        fontSize: 10.5.sp,
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
  // Cycled per item so circles alternate colour like the reference design —
  // the API only sends an icon glyph, not a colour, per item.
  static const List<Color> _benefitColors = [
    _P.violet,
    Color(0xFF1BA672),
    Color(0xFFF57C00),
    Color(0xFF1E5FFF),
    Color(0xFFE0457B),
    Color(0xFF0EA5E9),
  ];

  Widget _buildBenefitsGrid(List<PremiumFeatureItem> features, int columns) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.35,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (_, i) => _buildBenefitItem(features[i], i),
    );
  }

  Widget _buildBenefitItem(PremiumFeatureItem f, int i) {
    final color = _benefitColors[i % _benefitColors.length];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
          ),
          clipBehavior: Clip.antiAlias,
          child: f.imageUrl.isNotEmpty
              ? CachedNetworkImage(imageUrl: f.imageUrl, fit: BoxFit.cover)
              : Center(
                  child: FaIcon(
                    IconMapper.resolve(f.icon, fallbackIndex: i),
                    color: Colors.white,
                    size: 32,
                  ),
                ),
        ),
        const SizedBox(height: 10),
        Text(
          f.title,
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _P.ink,
            fontSize: 13.5.sp,
            height: 1.25,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------- INSTRUCTORS
  Widget _buildInstructors(List<PremiumInstructor> instructors) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (final i in instructors)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 34.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: i.videoUrl.isEmpty
                          ? null
                          : () => showYoutubeVideoDialog(context, i.videoUrl),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (i.thumbnailUrl.isNotEmpty)
                                CachedNetworkImage(
                                  imageUrl: i.thumbnailUrl,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, _, _) =>
                                      const _HeroFallback(),
                                  placeholder: (_, _) => const _HeroFallback(),
                                )
                              else
                                const _HeroFallback(),
                              if (i.videoUrl.isNotEmpty)
                                const Center(
                                  child: _PlayBadge(size: 44, iconSize: 22),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      i.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _P.ink,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------- VIDEOS
  Widget _buildVideos(List<PremiumVideo> videos) {
    final rest = videos.skip(1).toList();
    return Column(
      children: [
        _VideoTile(item: videos.first, large: true),
        if (rest.isNotEmpty) SizedBox(height: 1.5.h),
        for (var i = 0; i < rest.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: 1.5.h),
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
            padding: EdgeInsets.only(bottom: 1.5.h),
            child: _TestimonialCard(item: t),
          ),
      ],
    );
  }

  // ------------------------------------------------------------- PRICING
  Widget _buildPricingCard(
    BuildContext context,
    PremiumConfig config,
    PremiumPricing pricing,
    String ctaText,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [_P.violet, _P.violetDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events_rounded, color: _P.gold, size: 25),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  pricing.heading,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          if (pricing.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              pricing.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  pricing.discountedPrice,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _P.gold,
                    fontSize: 33.sp,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (pricing.originalPrice.isNotEmpty) ...[
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    pricing.originalPrice,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 16.5.sp,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.white70,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (pricing.priceNote.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              pricing.priceNote,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          if (pricing.benefits.isNotEmpty) ...[
            SizedBox(height: 2.h),
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
          SizedBox(height: 1.5.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _P.gold,
                foregroundColor: _P.ink,
                padding: EdgeInsets.symmetric(vertical: 1.8.h),
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
                      style: TextStyle(
                        fontSize: 15.5.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 21),
                ],
              ),
            ),
          ),
          if (pricing.offerBadgeText.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
                const SizedBox(width: 6),
                Text(
                  pricing.offerBadgeText,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMemberCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [_P.violet, _P.violetDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.verified_rounded, color: _P.gold, size: 39),
          const SizedBox(height: 10),
          Text(
            "You're a Premium Member",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.5.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Every feature above is already unlocked for you.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
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
              color: _P.violet,
              fontSize: 13.sp,
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

class _CheckLine extends StatelessWidget {
  final String text;
  const _CheckLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_box_rounded, color: _P.gold, size: 18),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
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
        color: Colors.white.withValues(alpha: 0.28),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white70, width: 2),
      ),
      child: Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
        size: iconSize,
      ),
    );
  }
}

class _HeroFallback extends StatelessWidget {
  const _HeroFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2A1B5E), Color(0xFF4B23B8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
                        fontSize: 10.sp,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _P.violet.withValues(alpha: 0.10),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < item.rating ? Icons.star_rounded : Icons.star_border_rounded,
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
                color: _P.ink,
                fontSize: 13.sp,
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
                backgroundColor: _P.violet.withValues(alpha: 0.15),
                backgroundImage: item.avatarUrl.isNotEmpty
                    ? CachedNetworkImageProvider(item.avatarUrl)
                    : null,
                child: item.avatarUrl.isEmpty
                    ? const Icon(Icons.person, color: _P.violet, size: 21)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    color: _P.ink,
                    fontSize: 13.sp,
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

class _BannerCard extends StatelessWidget {
  final PremiumBanner banner;
  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: banner.linkUrl.isEmpty
          ? null
          : () => launchUrlString(
              banner.linkUrl,
              mode: LaunchMode.externalApplication,
            ),
      child: ClipRRect(
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
                errorWidget: (_, _, _) => const SizedBox.shrink(),
              )
            else
              const SizedBox.shrink(),
            if (banner.text.isNotEmpty)
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    banner.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w800,
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
}
