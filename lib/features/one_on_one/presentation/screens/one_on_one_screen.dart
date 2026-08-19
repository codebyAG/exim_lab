import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:exim_lab/core/utils/icon_mapper.dart';
import 'package:exim_lab/core/widgets/youtube_video_dialog.dart';
import 'package:exim_lab/features/one_on_one/data/models/one_on_one_config_model.dart';
import 'package:exim_lab/features/one_on_one/presentation/providers/one_on_one_provider.dart';

/// Dark navy/violet theme — matches the approved "Option 2" reference design,
/// deliberately distinct from Premium's lighter violet look and the app's
/// default light theme.
class _C {
  static const bg = Color(0xFF0E1233);
  static const bgDeep = Color(0xFF171049);
  static const violet = Color(0xFF7C3AED);
  static const violetDeep = Color(0xFF5B21B6);
  static const green = Color(0xFF16A34A);
  static const greenDeep = Color(0xFF0F7A38);
  static const gold = Color(0xFFF5B400);
  static const ink = Color(0xFF17123A);
  static const body = Color(0xFF8A87B0);
  static const cardText = Color(0xFF1E1B4B);
}

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<OneOnOneProvider>().load();
    });
  }

  // Phase 1: the CTA button renders but is not wired up yet — WhatsApp
  // launch + analytics logging land in Phase 3.
  void _bookNow(BuildContext context, OneOnOnePricing pricing) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking opens soon — stay tuned!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OneOnOneProvider>();
    final config = provider.config;

    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: config == null
                  ? _buildPlaceholder(provider)
                  : RefreshIndicator(
                      color: _C.violet,
                      onRefresh: () =>
                          context.read<OneOnOneProvider>().load(force: true),
                      child: _buildContent(context, config),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.showBackButton)
            IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            )
          else
            const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _C.gold,
              borderRadius: BorderRadius.circular(20),
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
                    fontSize: 9.5.sp,
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
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: _C.violet));
    }
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: _C.violet, size: 44),
            SizedBox(height: 2.h),
            Text(
              "Couldn't load session details",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.violet,
                foregroundColor: Colors.white,
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
      padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 4.h),
      children: [
        _buildHeroText(config),
        if (config.heroVideo != null) ...[
          SizedBox(height: 2.h),
          _buildHeroVideo(config.heroVideo!),
        ],

        if (config.benefits.isNotEmpty) ...[
          SizedBox(height: 3.5.h),
          const _SectionTitle("WHAT YOU GET"),
          SizedBox(height: 1.8.h),
          _buildWhiteGrid(config.benefits, crossAxisCount: 2, aspectRatio: 1.5),
        ],

        if (config.journeySteps.isNotEmpty) ...[
          SizedBox(height: 3.5.h),
          const _SectionTitle("OUR HAND-HOLDING PROCESS"),
          SizedBox(height: 1.8.h),
          _buildJourneySteps(config.journeySteps),
        ],

        if (config.uniquePoints.isNotEmpty) ...[
          SizedBox(height: 3.5.h),
          const _SectionTitle("WHY 1-ON-1 IS UNIQUE"),
          SizedBox(height: 1.8.h),
          _buildWhiteGrid(
            config.uniquePoints,
            crossAxisCount: 2,
            aspectRatio: 1.5,
          ),
        ],

        if (config.highlightBanner != null) ...[
          SizedBox(height: 3.5.h),
          _buildHighlightBanner(config.highlightBanner!),
        ],

        if (config.experienceVideos.isNotEmpty) ...[
          SizedBox(height: 3.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "REAL EXPERIENCES",
                style: TextStyle(
                  color: _C.gold,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "View All",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white54,
                    size: 11,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 1.8.h),
          _buildVideos(config.experienceVideos),
        ],

        if (config.trustBadges.isNotEmpty) ...[
          SizedBox(height: 3.h),
          _buildTrustBadges(config.trustBadges),
        ],

        if (config.pricing != null) ...[
          SizedBox(height: 3.h),
          _buildPricingCard(context, config.pricing!),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------- HERO
  Widget _buildHeroText(OneOnOneConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          config.heading,
          style: TextStyle(
            color: Colors.white,
            fontSize: 21.sp,
            height: 1.15,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (config.subheading.isNotEmpty) ...[
          SizedBox(height: 1.h),
          Text(
            config.subheading,
            style: TextStyle(
              color: _C.body,
              fontSize: 12.5.sp,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeroVideo(OneOnOneHeroVideo hero) {
    return Column(
      children: [
        GestureDetector(
          onTap: hero.videoUrl.isEmpty
              ? null
              : () => showYoutubeVideoDialog(context, hero.videoUrl),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (hero.thumbnailUrl.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: hero.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => const _HeroFallback(),
                      placeholder: (_, _) => const _HeroFallback(),
                    )
                  else
                    const _HeroFallback(),
                  if (hero.videoUrl.isNotEmpty)
                    const Center(child: _PlayBadge(size: 58, iconSize: 30)),
                ],
              ),
            ),
          ),
        ),
        if (hero.videoUrl.isNotEmpty && hero.ctaText.isNotEmpty) ...[
          SizedBox(height: 1.5.h),
          GestureDetector(
            onTap: () => showYoutubeVideoDialog(context, hero.videoUrl),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.6.h),
              decoration: BoxDecoration(
                color: _C.violet,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    hero.ctaText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.play_circle_fill_rounded,
                    color: Colors.white,
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

  // ------------------------------------------------------- WHITE ITEM GRID
  // Shared by "What You Get" and "Why 1-on-1 Is Unique" — white floating
  // cards on the dark background, matching the reference design.
  static const List<Color> _itemColors = [
    _C.violet,
    Color(0xFF2563EB),
    Color(0xFF16A34A),
    Color(0xFFF59E0B),
    Color(0xFFE0457B),
    Color(0xFF0EA5E9),
  ];

  Widget _buildWhiteGrid(
    List<OneOnOneItem> items, {
    required int crossAxisCount,
    required double aspectRatio,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: aspectRatio,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
        ),
        itemBuilder: (_, i) {
          final item = items[i];
          final color = _itemColors[i % _itemColors.length];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: FaIcon(
                    IconMapper.resolve(item.icon, fallbackIndex: i),
                    color: Colors.white,
                    size: 17,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _C.cardText,
                  fontSize: 10.5.sp,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (item.description.isNotEmpty)
                Text(
                  item.description,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _C.body,
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------- JOURNEY
  Widget _buildJourneySteps(List<OneOnOneItem> steps) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == steps.length - 1 ? 0 : 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _itemColors[i % _itemColors.length],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          steps[i].title,
                          style: TextStyle(
                            color: _C.cardText,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (steps[i].description.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            steps[i].description,
                            style: TextStyle(
                              color: _C.body,
                              fontSize: 10.sp,
                              height: 1.3,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
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
        gradient: const LinearGradient(
          colors: [_C.violetDeep, _C.violet],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (banner.heading.isNotEmpty)
            Text(
              banner.heading,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          if (banner.subheading.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              banner.subheading,
              style: TextStyle(
                color: _C.gold,
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          if (banner.items.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Row(
              children: banner.items
                  .map(
                    (item) => Expanded(
                      child: Column(
                        children: [
                          Text(
                            item.icon.isNotEmpty ? item.icon : '⭐',
                            style: TextStyle(fontSize: 15.sp),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
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
  Widget _buildTrustBadges(List<OneOnOneItem> badges) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 18,
      runSpacing: 10,
      children: badges
          .map(
            (b) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: _C.green,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  b.label,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  // ------------------------------------------------------------- PRICING
  Widget _buildPricingCard(BuildContext context, OneOnOnePricing pricing) {
    final urgency = pricing.effectiveUrgencyText;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [_C.greenDeep, _C.green],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pricing.heading,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              height: 1.25,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (pricing.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              pricing.description,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          SizedBox(height: 1.8.h),
          if (pricing.priceNote.isNotEmpty)
            Text(
              pricing.priceNote,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  pricing.discountedPrice,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.sp,
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
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.white70,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 1.8.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.gold,
                foregroundColor: _C.ink,
                padding: EdgeInsets.symmetric(vertical: 1.7.h),
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
                      style: TextStyle(
                        fontSize: 13.sp,
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
          if (urgency.isNotEmpty) ...[
            const SizedBox(height: 10),
            Center(
              child: Text(
                urgency,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
          if (pricing.disclaimerText.isNotEmpty) ...[
            const SizedBox(height: 6),
            Center(
              child: Text(
                pricing.disclaimerText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
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
      style: TextStyle(
        color: _C.gold,
        fontSize: 11.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.1,
      ),
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
      ),
      child: Icon(Icons.play_arrow_rounded, color: _C.ink, size: iconSize),
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
          colors: [_C.bgDeep, _C.violetDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
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
                    colors: [Colors.transparent, Colors.black87],
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
                      fontSize: 9.5.sp,
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
