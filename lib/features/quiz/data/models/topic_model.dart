class TopicModel {
  final String id;
  final String title;
  final String description;
  final bool isActive;
  final bool hasAttempted;
  final int totalQuestions;
  final int totalAnswers;
  final String? attemptId;

  TopicModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isActive,
    required this.hasAttempted,
    required this.totalQuestions,
    required this.totalAnswers,
    this.attemptId,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? false,
      hasAttempted: json['hasAttempted'] ?? false,
      totalQuestions: json['totalQuestions'] ?? 0,
      totalAnswers: json['totalAnswers'] ?? 0,
      attemptId: json['attemptId'],
    );
  }
}
