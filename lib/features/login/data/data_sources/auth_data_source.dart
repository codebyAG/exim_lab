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
  }) async {
    return await callApi(
      ApiConstants.verifyOtp,
      requestData: {
        "mobile": mobile,
        "role": "USER",
        "otp": otp,
        "organizationId": AppContants.organizationId,
      },
      parser: (json) => json as Map<String, dynamic>,
      methodType: MethodType.post,
    );
  }
}
