import 'package:flutter/material.dart';
import '../../data/models/journey_model.dart';
import '../../data/repositories/journey_repository.dart';
import 'dart:developer' as developer;

class JourneyProvider with ChangeNotifier {
  final JourneyRepository _repository = JourneyRepository();

  List<JourneyStep> _importSteps = [];
  List<JourneyStep> _exportSteps = [];
  
  bool _isLoading = false;
  String? _error;

  List<JourneyStep> get importSteps => _importSteps;
  List<JourneyStep> get exportSteps => _exportSteps;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchJourney(String type) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Fetch Config and Progress in parallel
      final results = await Future.wait([
        _repository.getJourneyConfig(type),
        _repository.getJourneyProgress(type),
      ]);

      final List<JourneyStep> steps = results[0] as List<JourneyStep>;
      final JourneyProgress progress = results[1] as JourneyProgress;

      // 2. Process steps based on progress
      final processedSteps = steps.map((step) {
        JourneyStepStatus status = JourneyStepStatus.locked;
        if (progress.completedSteps.contains(step.id)) {
          status = JourneyStepStatus.completed;
        } else if (step.id == progress.lastActiveStep) {
          status = JourneyStepStatus.active;
        }
        return step.copyWith(status: status);
      }).toList();

      if (type == 'import') {
        _importSteps = processedSteps;
      } else {
        _exportSteps = processedSteps;
      }
    } catch (e) {
      _error = e.toString();
      developer.log("⚠️ Journey Fetch Error ($type): $e", name: "JOURNEY");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markStepCompleted(String type, int stepId, {Map<String, dynamic>? result}) async {
    try {
      final steps = type == 'import' ? _importSteps : _exportSteps;
      final completedIds = steps
          .where((s) => s.status == JourneyStepStatus.completed)
          .map((s) => s.id)
          .toList();
      
      if (!completedIds.contains(stepId)) {
        completedIds.add(stepId);
      }

      // Next step becomes active
      final nextStepId = stepId + 1;

      await _repository.syncProgress(
        type: type,
        completedSteps: completedIds,
        lastActiveStep: nextStepId,
        lastStepResult: result,
      );

      // Refresh local state
      await fetchJourney(type);
    } catch (e) {
      developer.log("⚠️ Failed to sync step $stepId: $e", name: "JOURNEY");
    }
  }
}
