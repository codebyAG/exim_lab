// Models for GET /api/premium-features/config.
//
// Arrays arrive already filtered (inactive removed) and sorted by `order`
// server-side, so they are rendered in the given order without re-sorting.

class PremiumConfig {
  final String heading;
  final String subheading;
  final String ctaText;
  final String ctaWhatsappNumber;
  final String ctaWhatsappMessage;
  final String bannerImageUrl;
  final String bannerText;
  final PremiumVideo? introVideo;
  final int gridColumns;
  final String featuresHeading;
  final String instructorsHeading;
  final String videosHeading;
  final String testimonialsHeading;
  final List<PremiumFeatureItem> features;
  final List<PremiumStat> stats;
  final List<PremiumInstructor> instructors;
  final List<PremiumVideo> videos;
  final List<PremiumTestimonial> testimonials;
  final List<PremiumBanner> banners;
  final PremiumPricing? pricing;

  const PremiumConfig({
    required this.heading,
    required this.subheading,
    required this.ctaText,
    required this.ctaWhatsappNumber,
    required this.ctaWhatsappMessage,
    required this.bannerImageUrl,
    required this.bannerText,
    required this.introVideo,
    required this.gridColumns,
    required this.featuresHeading,
    required this.instructorsHeading,
    required this.videosHeading,
    required this.testimonialsHeading,
    required this.features,
    required this.stats,
    required this.instructors,
    required this.videos,
    required this.testimonials,
    required this.banners,
    required this.pricing,
  });

  factory PremiumConfig.fromJson(Map<String, dynamic> json) {
    List<T> list<T>(String key, T Function(Map<String, dynamic>) fromJson) =>
        (json[key] as List?)
            ?.whereType<Map>()
            .map((e) => fromJson(Map<String, dynamic>.from(e)))
            .toList() ??
        const [];

    final intro = json['introVideo'];
    final pricing = json['pricing'];

    return PremiumConfig(
      heading: json['heading']?.toString() ?? 'Go Premium',
      subheading:
          json['subheading']?.toString() ?? 'Learn Import Export the Smart Way',
      ctaText: json['ctaText']?.toString() ?? 'Get Premium Now',
      ctaWhatsappNumber: json['ctaWhatsappNumber']?.toString() ?? '',
      ctaWhatsappMessage: json['ctaWhatsappMessage']?.toString() ?? '',
      bannerImageUrl: json['bannerImageUrl']?.toString() ?? '',
      bannerText: json['bannerText']?.toString() ?? '',
      introVideo: intro is Map
          ? PremiumVideo.fromJson(Map<String, dynamic>.from(intro))
          : null,
      gridColumns: _gridColumns(json['gridColumns']),
      featuresHeading: json['featuresHeading']?.toString() ?? "What You'll Get",
      instructorsHeading:
          json['instructorsHeading']?.toString() ?? 'Meet Your Teachers',
      videosHeading: json['videosHeading']?.toString() ?? 'Top Learning Videos',
      testimonialsHeading:
          json['testimonialsHeading']?.toString() ?? 'What Learners Say',
      features: list('features', PremiumFeatureItem.fromJson),
      stats: list('stats', PremiumStat.fromJson),
      instructors: list('instructors', PremiumInstructor.fromJson),
      videos: list('videos', PremiumVideo.fromJson),
      testimonials: list('testimonials', PremiumTestimonial.fromJson),
      banners: list('banners', PremiumBanner.fromJson),
      pricing: pricing is Map
          ? PremiumPricing.fromJson(Map<String, dynamic>.from(pricing))
          : null,
    );
  }

  /// Only 2, 3 and 4 column grids are supported by the layout.
  static int _gridColumns(dynamic raw) {
    final n = (raw is num) ? raw.toInt() : int.tryParse('$raw') ?? 3;
    return (n >= 2 && n <= 4) ? n : 3;
  }

  /// Banners declared for one of the five fixed layout slots.
  List<PremiumBanner> bannersAt(String position) =>
      banners.where((b) => b.position == position).toList();
}

class PremiumFeatureItem {
  final String id;
  final String icon;
  final String imageUrl;
  final String title;
  final String description;

  const PremiumFeatureItem({
    required this.id,
    required this.icon,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  factory PremiumFeatureItem.fromJson(Map<String, dynamic> json) =>
      PremiumFeatureItem(
        id: json['id']?.toString() ?? '',
        icon: json['icon']?.toString() ?? '',
        imageUrl: json['imageUrl']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
      );
}

class PremiumStat {
  final String id;
  final String icon;
  final String value;
  final String label;

  const PremiumStat({
    required this.id,
    required this.icon,
    required this.value,
    required this.label,
  });

  factory PremiumStat.fromJson(Map<String, dynamic> json) => PremiumStat(
    id: json['id']?.toString() ?? '',
    icon: json['icon']?.toString() ?? '',
    value: json['value']?.toString() ?? '',
    label: json['label']?.toString() ?? '',
  );
}

class PremiumInstructor {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String name;

  const PremiumInstructor({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.name,
  });

  factory PremiumInstructor.fromJson(Map<String, dynamic> json) =>
      PremiumInstructor(
        id: json['id']?.toString() ?? '',
        videoUrl: json['videoUrl']?.toString() ?? '',
        thumbnailUrl: json['thumbnailUrl']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
      );
}

class PremiumVideo {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String duration;
  final String title;

  const PremiumVideo({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.duration,
    required this.title,
  });

  factory PremiumVideo.fromJson(Map<String, dynamic> json) => PremiumVideo(
    id: json['id']?.toString() ?? '',
    videoUrl: json['videoUrl']?.toString() ?? '',
    thumbnailUrl: json['thumbnailUrl']?.toString() ?? '',
    duration: json['duration']?.toString() ?? '',
    title: json['title']?.toString() ?? '',
  );
}

class PremiumTestimonial {
  final String id;
  final int rating;
  final String quote;
  final String name;
  final String avatarUrl;

  const PremiumTestimonial({
    required this.id,
    required this.rating,
    required this.quote,
    required this.name,
    required this.avatarUrl,
  });

  factory PremiumTestimonial.fromJson(Map<String, dynamic> json) =>
      PremiumTestimonial(
        id: json['id']?.toString() ?? '',
        rating: ((json['rating'] as num?)?.toInt() ?? 5).clamp(0, 5),
        quote: json['quote']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        avatarUrl: json['avatarUrl']?.toString() ?? '',
      );
}

class PremiumBanner {
  final String id;
  final String imageUrl;
  final String text;
  final String linkUrl;

  /// One of: after_hero, after_stats, after_features, after_videos,
  /// after_testimonials.
  final String position;

  const PremiumBanner({
    required this.id,
    required this.imageUrl,
    required this.text,
    required this.linkUrl,
    required this.position,
  });

  factory PremiumBanner.fromJson(Map<String, dynamic> json) => PremiumBanner(
    id: json['id']?.toString() ?? '',
    imageUrl: json['imageUrl']?.toString() ?? '',
    text: json['text']?.toString() ?? '',
    linkUrl: json['linkUrl']?.toString() ?? '',
    position: json['position']?.toString() ?? '',
  );
}

class PremiumPricing {
  final String heading;
  final String description;
  final List<String> benefits;
  final String offerBadgeText;
  final String originalPrice;
  final String discountedPrice;
  final String priceNote;

  const PremiumPricing({
    required this.heading,
    required this.description,
    required this.benefits,
    required this.offerBadgeText,
    required this.originalPrice,
    required this.discountedPrice,
    required this.priceNote,
  });

  factory PremiumPricing.fromJson(Map<String, dynamic> json) => PremiumPricing(
    heading: json['heading']?.toString() ?? 'Go Premium',
    description: json['description']?.toString() ?? '',
    benefits:
        (json['benefits'] as List?)?.map((e) => e.toString()).toList() ??
        const [],
    offerBadgeText: json['offerBadgeText']?.toString() ?? '',
    originalPrice: json['originalPrice']?.toString() ?? '',
    discountedPrice: json['discountedPrice']?.toString() ?? '',
    priceNote: json['priceNote']?.toString() ?? '',
  );
}

/// Fixed banner slots in the premium page layout.
class PremiumBannerSlot {
  static const afterHero = 'after_hero';
  static const afterStats = 'after_stats';
  static const afterFeatures = 'after_features';
  static const afterVideos = 'after_videos';
  static const afterTestimonials = 'after_testimonials';
}
