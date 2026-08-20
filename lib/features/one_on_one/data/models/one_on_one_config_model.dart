// Models for GET /api/one-on-one/config.
//
// Arrays arrive already filtered (inactive removed) and sorted by `order`
// server-side, so they are rendered in the given order without re-sorting.

class OneOnOneConfig {
  final String heading;
  final String subheading;
  final OneOnOneHeroVideo? heroVideo;
  final List<OneOnOneItem> benefits;
  final List<OneOnOneItem> journeySteps;
  final List<OneOnOneItem> uniquePoints;
  final OneOnOneHighlightBanner? highlightBanner;
  final List<OneOnOneVideo> experienceVideos;
  final List<OneOnOneItem> trustBadges;
  final OneOnOnePricing? pricing;

  const OneOnOneConfig({
    required this.heading,
    required this.subheading,
    required this.heroVideo,
    required this.benefits,
    required this.journeySteps,
    required this.uniquePoints,
    required this.highlightBanner,
    required this.experienceVideos,
    required this.trustBadges,
    required this.pricing,
  });

  factory OneOnOneConfig.fromJson(Map<String, dynamic> json) {
    List<T> list<T>(String key, T Function(Map<String, dynamic>) fromJson) =>
        (json[key] as List?)
            ?.whereType<Map>()
            .map((e) => fromJson(Map<String, dynamic>.from(e)))
            .toList() ??
        const [];

    final hero = json['heroVideo'];
    final highlight = json['highlightBanner'];
    final pricing = json['pricing'];

    return OneOnOneConfig(
      heading: json['heading']?.toString() ?? 'One-on-One Classes',
      subheading: json['subheading']?.toString() ?? '',
      heroVideo: hero is Map
          ? OneOnOneHeroVideo.fromJson(Map<String, dynamic>.from(hero))
          : null,
      benefits: list('benefits', OneOnOneItem.fromJson),
      journeySteps: list('journeySteps', OneOnOneItem.fromJson),
      uniquePoints: list('uniquePoints', OneOnOneItem.fromJson),
      highlightBanner: highlight is Map
          ? OneOnOneHighlightBanner.fromJson(
              Map<String, dynamic>.from(highlight),
            )
          : null,
      experienceVideos: list('experienceVideos', OneOnOneVideo.fromJson),
      trustBadges: list('trustBadges', OneOnOneItem.fromJson),
      pricing: pricing is Map
          ? OneOnOnePricing.fromJson(Map<String, dynamic>.from(pricing))
          : null,
    );
  }
}

class OneOnOneHeroVideo {
  final String videoUrl;
  final String thumbnailUrl;
  final String ctaText;

  const OneOnOneHeroVideo({
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.ctaText,
  });

  factory OneOnOneHeroVideo.fromJson(Map<String, dynamic> json) =>
      OneOnOneHeroVideo(
        videoUrl: json['videoUrl']?.toString() ?? '',
        thumbnailUrl: json['thumbnailUrl']?.toString() ?? '',
        ctaText: json['ctaText']?.toString() ?? 'Watch',
      );
}

/// Shared shape for benefits / journeySteps / uniquePoints / trustBadges —
/// all icon + title (+ optional description).
class OneOnOneItem {
  final String id;
  final String icon;
  final String title;
  final String label;
  final String description;

  const OneOnOneItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.label,
    required this.description,
  });

  factory OneOnOneItem.fromJson(Map<String, dynamic> json) => OneOnOneItem(
    id: json['id']?.toString() ?? '',
    icon: json['icon']?.toString() ?? '',
    title: json['title']?.toString() ?? '',
    label: json['label']?.toString() ?? '',
    description: json['description']?.toString() ?? '',
  );
}

class OneOnOneHighlightBanner {
  final String heading;
  final String subheading;
  final List<OneOnOneItem> items;

  const OneOnOneHighlightBanner({
    required this.heading,
    required this.subheading,
    required this.items,
  });

  factory OneOnOneHighlightBanner.fromJson(Map<String, dynamic> json) =>
      OneOnOneHighlightBanner(
        heading: json['heading']?.toString() ?? '',
        subheading: json['subheading']?.toString() ?? '',
        items:
            (json['items'] as List?)
                ?.whereType<Map>()
                .map((e) => OneOnOneItem.fromJson(Map<String, dynamic>.from(e)))
                .toList() ??
            const [],
      );
}

class OneOnOneVideo {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String duration;
  final String title;

  const OneOnOneVideo({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.duration,
    required this.title,
  });

  factory OneOnOneVideo.fromJson(Map<String, dynamic> json) => OneOnOneVideo(
    id: json['id']?.toString() ?? '',
    videoUrl: json['videoUrl']?.toString() ?? '',
    thumbnailUrl: json['thumbnailUrl']?.toString() ?? '',
    duration: json['duration']?.toString() ?? '',
    title: json['title']?.toString() ?? '',
  );
}

class OneOnOnePricing {
  final String heading;
  final String description;
  final String originalPrice;
  final String discountedPrice;
  final String priceNote;
  final String ctaText;
  final String ctaWhatsappNumber;
  final String ctaWhatsappMessage;
  final int slotsLeft;
  final String urgencyText;
  final String disclaimerText;

  const OneOnOnePricing({
    required this.heading,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.priceNote,
    required this.ctaText,
    required this.ctaWhatsappNumber,
    required this.ctaWhatsappMessage,
    required this.slotsLeft,
    required this.urgencyText,
    required this.disclaimerText,
  });

  factory OneOnOnePricing.fromJson(Map<String, dynamic> json) =>
      OneOnOnePricing(
        heading: json['heading']?.toString() ?? 'Book Your 1-on-1 Session',
        description: json['description']?.toString() ?? '',
        originalPrice: json['originalPrice']?.toString() ?? '',
        discountedPrice: json['discountedPrice']?.toString() ?? '',
        priceNote: json['priceNote']?.toString() ?? '',
        ctaText: json['ctaText']?.toString() ?? 'Book Now',
        ctaWhatsappNumber: json['ctaWhatsappNumber']?.toString() ?? '',
        ctaWhatsappMessage: json['ctaWhatsappMessage']?.toString() ?? '',
        slotsLeft: (json['slotsLeft'] as num?)?.toInt() ?? 0,
        urgencyText: json['urgencyText']?.toString() ?? '',
        disclaimerText: json['disclaimerText']?.toString() ?? '',
      );

  /// Prefer `urgencyText`; fall back to a simple synthesized line from
  /// `slotsLeft` only when urgencyText is empty.
  String get effectiveUrgencyText {
    if (urgencyText.isNotEmpty) return urgencyText;
    if (slotsLeft > 0) return "Only $slotsLeft seats left";
    return '';
  }

  static num? _numeric(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^0-9.]'), '');
    return digits.isEmpty ? null : num.tryParse(digits);
  }

  /// "You Save ₹2,000 (67% OFF)" line, computed from the two price strings.
  /// Null when either price isn't parseable as a plain number.
  String? get savingsLabel {
    final original = _numeric(originalPrice);
    final discounted = _numeric(discountedPrice);
    if (original == null || discounted == null || original <= discounted) {
      return null;
    }
    final saved = original - discounted;
    final percent = ((saved / original) * 100).round();
    return "You Save ₹${saved.toStringAsFixed(0)} ($percent% OFF)";
  }
}
