class AttemptModel {
  final String attemptId;
  final String topicId;
  final String userId;
  final String status;
  final int currentQuestionIndex;
  final List<dynamic> answers;

  AttemptModel({
    required this.attemptId,
    required this.topicId,
    required this.userId,
    required this.status,
    required this.currentQuestionIndex,
    required this.answers,
  });

  bool get isCompleted => status == "COMPLETED";

  factory AttemptModel.fromJson(Map<String, dynamic> json) {
    return AttemptModel(
      attemptId: json['_id'] ?? '',
      topicId: json['topicId'] ?? '',
      userId: json['userId'] ?? '',
      status: json['status'] ?? 'IN_PROGRESS',
      currentQuestionIndex: json['currentQuestionIndex'] ?? 0,
      answers: json['answers'] ?? [],
    );
  }
}
