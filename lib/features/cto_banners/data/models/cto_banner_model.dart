class CtoBannerModel {
  final String id;
  final String title;
  final String description;
  final String ctaText;
  final String ctaUrl;
  final String imageUrl;

  CtoBannerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.ctaText,
    required this.ctaUrl,
    required this.imageUrl,
  });

  factory CtoBannerModel.fromJson(Map<String, dynamic> json) {
    return CtoBannerModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      ctaText: json['ctaText'] ?? '',
      ctaUrl: json['ctaUrl'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
