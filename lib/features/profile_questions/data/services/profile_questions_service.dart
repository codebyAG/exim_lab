import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/profile_questions/data/models/profile_questions_model.dart';

class ProfileQuestionsService {
  ProfileQuestionsData _parse(dynamic json) {
    final data = json is Map && json['data'] != null ? json['data'] : json;
    return ProfileQuestionsData.fromJson(Map<String, dynamic>.from(data));
  }

  Future<ProfileQuestionsData> fetch() async {
    return await callApi(ApiConstants.profileQuestions, parser: _parse);
  }

  Future<ProfileQuestionsData> submitAnswer({
    required String questionKey,
    String? optionValue,
    String? textValue,
  }) async {
    return await callApi(
      ApiConstants.profileQuestionsAnswers,
      methodType: MethodType.post,
      requestData: {
        'questionKey': questionKey,
        if (optionValue != null) 'optionValue': optionValue,
        if (textValue != null) 'textValue': textValue,
      },
      parser: _parse,
    );
  }
}
