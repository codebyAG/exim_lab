class QuestionModel {
  final String id;
  final String prompt;
  final List<String> options;
  final int correctOptionIndex;
  final int order;

  QuestionModel({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctOptionIndex,
    required this.order,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['_id'] ?? '',
      prompt: json['prompt'] ?? '',
      options:
          (json['options'] as List?)
              ?.map((e) => e['text'].toString())
              .toList() ??
          [],
      correctOptionIndex: json['correctOptionIndex'] ?? -1,
      order: json['order'] ?? 0,
    );
  }
}
