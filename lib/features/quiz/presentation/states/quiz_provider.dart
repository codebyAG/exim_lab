import 'package:flutter/material.dart';
import 'package:exim_lab/features/quiz/data/data_sources/quiz_data_source.dart';
import 'package:exim_lab/features/quiz/data/models/attempt_model.dart';
import 'package:exim_lab/features/quiz/data/models/question_model.dart';
import 'package:exim_lab/features/quiz/data/models/topic_model.dart';

class QuizProvider extends ChangeNotifier {
  final QuizDataSource _dataSource = QuizDataSource();

  List<TopicModel> _topics = [];
  List<QuestionModel> _questions = [];
  AttemptModel? _currentAttempt;
  bool _isLoading = false;
  String? _error;

  List<TopicModel> get topics => _topics;
  List<QuestionModel> get questions => _questions;
  AttemptModel? get currentAttempt => _currentAttempt;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTopics(String userId) async {
    _setLoading(true);
    try {
      _topics = await _dataSource.getTopics(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> startQuiz(String userId, String topicId) async {
    _setLoading(true);
    try {
      _questions = await _dataSource.getQuestions(topicId);
      _currentAttempt = await _dataSource.startAttempt(userId, topicId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> submitAnswer(String questionId, int optionIndex) async {
    if (_currentAttempt == null) return;

    _setLoading(true);
    try {
      _currentAttempt = await _dataSource.submitAnswer(
        _currentAttempt!.attemptId,
        questionId,
        optionIndex,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
