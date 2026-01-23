import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/quiz/data/models/attempt_model.dart';
import 'package:exim_lab/features/quiz/data/models/question_model.dart';
import 'package:exim_lab/features/quiz/data/models/topic_model.dart';

class QuizDataSource {
  Future<List<TopicModel>> getTopics(String userId) async {
    return await callApi(
      "${ApiConstants.quizTopics}?page=1&limit=20&userId=$userId",
      parser: (json) {
        return (json['data'] as List)
            .map((e) => TopicModel.fromJson(e))
            .toList();
      },
      methodType: MethodType.get,
    );
  }

  Future<List<QuestionModel>> getQuestions(String topicId) async {
    return await callApi(
      "${ApiConstants.getAllQuestions}/$topicId",
      parser: (json) {
        return (json['questions'] as List)
            .map((e) => QuestionModel.fromJson(e))
            .toList();
      },
      methodType: MethodType.get,
    );
  }

  Future<AttemptModel> startAttempt(String userId, String topicId) async {
    return await callApi(
      ApiConstants.quizAttempts,
      parser: (json) => AttemptModel.fromJson(json),
      methodType: MethodType.post,
      requestData: {"userId": userId, "topicId": topicId, "restart": true},
    );
  }

  Future<AttemptModel> submitAnswer(
    String attemptId,
    String questionId,
    int selectedOptionIndex,
  ) async {
    return await callApi(
      "${ApiConstants.quizAttempts}/$attemptId/answer",
      parser: (json) => AttemptModel.fromJson(json),
      methodType: MethodType.post,
      requestData: {
        "questionId": questionId,
        "selectedOptionIndex": selectedOptionIndex,
      },
    );
  }
}
