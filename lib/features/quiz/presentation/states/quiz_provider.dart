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

  String? _currentUserId;
  String? _currentTopicId;

  Future<void> startQuiz(String userId, String topicId) async {
    _setLoading(true);
    _currentUserId = userId;
    _currentTopicId = topicId;
    _currentAttempt = null; // Reset attempt
    try {
      _questions = await _dataSource.getQuestions(topicId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> submitAnswer(String questionId, int optionIndex) async {
    _setLoading(true);
    try {
      // Lazy create attempt if not exists
      if (_currentAttempt == null) {
        if (_currentUserId == null || _currentTopicId == null) {
          throw Exception("Session invalid");
        }
        _currentAttempt = await _dataSource.startAttempt(
          _currentUserId!,
          _currentTopicId!,
        );
      }

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
