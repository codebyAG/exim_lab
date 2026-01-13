class CourseModel {
  final String id;
  final String title;
  final String description;
  final double basePrice;
  final bool isPublished;
  final DateTime createdAt;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.basePrice,
    required this.isPublished,
    required this.createdAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      basePrice: (json['basePrice'] ?? 0).toDouble(),
      isPublished: json['isPublished'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
