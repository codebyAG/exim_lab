import 'package:flutter/material.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/profile_questions/data/models/profile_questions_model.dart';
import 'package:exim_lab/features/profile_questions/data/services/profile_questions_service.dart';

class ProfileQuestionsProvider extends ChangeNotifier {
  final ProfileQuestionsService _service = ProfileQuestionsService();

  ProfileQuestionsData? data;
  bool isLoading = false;
  bool isSubmitting = false;

  Future<void> fetch() async {
    isLoading = true;
    notifyListeners();
    try {
      data = await _service.fetch();
    } catch (_) {
      // Keep it silent — an unavailable config just means no banner renders.
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Returns null on success (and updates [data] from the server's response),
  /// or a human-readable error message on failure.
  Future<String?> submitAnswer({
    required String questionKey,
    String? optionValue,
    String? textValue,
  }) async {
    isSubmitting = true;
    notifyListeners();
    try {
      data = await _service.submitAnswer(
        questionKey: questionKey,
        optionValue: optionValue,
        textValue: textValue,
      );
      return null;
    } on ApiException catch (e) {
      return e.message;
    } catch (e) {
      return 'Something went wrong. Please try again.';
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
