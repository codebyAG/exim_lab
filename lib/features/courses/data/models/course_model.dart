class CourseModel {
  final String id;
  final String title;
  final String description;
  final double basePrice;
  final bool isPublished;
  final DateTime? createdAt;
  final DateTime? enrolledAt;
  final String? imageUrl;
  final int? completionPercentage;
  final DateTime? progressUpdatedAt;
  final double? rating;
  final int? learnersCount;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.basePrice,
    required this.isPublished,
    this.createdAt,
    this.enrolledAt,
    this.imageUrl,
    this.completionPercentage,
    this.progressUpdatedAt,
    this.rating,
    this.learnersCount,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      basePrice: (json['basePrice'] ?? 0).toDouble(),
      isPublished: json['isPublished'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      enrolledAt: json['enrolledAt'] != null
          ? DateTime.parse(json['enrolledAt'])
          : null,
      imageUrl: json['imageUrl'],
      completionPercentage: (json['completionPercentage'] ?? 0).toInt(),
      progressUpdatedAt: json['progressUpdatedAt'] != null
          ? DateTime.parse(json['progressUpdatedAt'])
          : null,
      rating: (json['rating'] as num?)?.toDouble(),
      learnersCount: (json['learnersCount'] as num?)?.toInt(),
    );
  }
}
