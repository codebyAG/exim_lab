import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/constants/app_contants.dart';
import 'package:exim_lab/core/functions/api_call.dart';

class AuthDataSource {
  Future<Map<String, dynamic>> sendOtp(String mobile) async {
    return await callApi(
      ApiConstants.auth,
      requestData: {"mobile": mobile, "role": "USER"},
      parser: (json) => json as Map<String, dynamic>,
      methodType: MethodType.post,
    );
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String mobile,
    required String otp,
    String? fcmToken,
  }) async {
    final Map<String, dynamic> body = {
      "mobile": mobile,
      "role": "USER",
      "otp": otp,
      "organizationId": AppContants.organizationId,
    };

    if (fcmToken != null) {
      body['fcm_token'] = fcmToken;
    }

    return await callApi(
      ApiConstants.verifyOtp,
      requestData: body,
      parser: (json) => json as Map<String, dynamic>,
      methodType: MethodType.post,
    );
  }

  Future<Map<String, dynamic>> getProfile() async {
    return await callApi(
      ApiConstants.userProfile,
      requestData: {},
      parser: (json) => json as Map<String, dynamic>,
      methodType: MethodType.get,
    );
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    return await callApi(
      ApiConstants.userProfile,
      requestData: data,
      parser: (json) => json as Map<String, dynamic>,
      methodType: MethodType.put,
    );
  }
}
