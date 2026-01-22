class TopicModel {
  final String id;
  final String title;
  final String description;
  final bool isActive;
  final bool hasAttempted;

  TopicModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isActive,
    required this.hasAttempted,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? false,
      hasAttempted: json['hasAttempted'] ?? false,
    );
  }
}
