import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import '../models/journey_model.dart';

class JourneyRemoteDataSource {
  Future<List<JourneyStep>> getJourneyConfig(String type) async {
    return await callApi(
      "${ApiConstants.journeyConfig}?journeyType=$type",
      parser: (json) {
        final List stepsData = json['data']['steps'] ?? [];
        return stepsData.map((s) => JourneyStep.fromJson(s)).toList();
      },
    );
  }

  Future<JourneyProgress> getJourneyProgress(String type) async {
    return await callApi(
      "${ApiConstants.journeyProgress}?journeyType=$type",
      parser: (json) => JourneyProgress.fromJson(json['data']),
    );
  }

  Future<void> updateJourneyProgress({
    required String type,
    required List<int> completedSteps,
    required int lastActiveStep,
    Map<String, dynamic>? lastStepResult,
  }) async {
    final body = {
      "completedSteps": completedSteps,
      "lastActiveStep": lastActiveStep,
    };
    if (lastStepResult != null) {
      body["stepResult"] = lastStepResult;
    }

    await callApi(
      "${ApiConstants.journeyProgress}?journeyType=$type",
      methodType: MethodType.put,
      requestData: body,
      parser: (json) => json,
    );
  }
}

class JourneyRepository {
  final JourneyRemoteDataSource _dataSource = JourneyRemoteDataSource();

  Future<List<JourneyStep>> getJourneyConfig(String type) =>
      _dataSource.getJourneyConfig(type);

  Future<JourneyProgress> getJourneyProgress(String type) =>
      _dataSource.getJourneyProgress(type);

  Future<void> syncProgress({
    required String type,
    required List<int> completedSteps,
    required int lastActiveStep,
    Map<String, dynamic>? lastStepResult,
  }) =>
      _dataSource.updateJourneyProgress(
        type: type,
        completedSteps: completedSteps,
        lastActiveStep: lastActiveStep,
        lastStepResult: lastStepResult,
      );
}
