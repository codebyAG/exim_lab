import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/module_manager/data/models/module_config.dart';

class ModuleService {
  Future<ModuleConfig?> fetchConfig() async {
    try {
      return await callApi<ModuleConfig?>(
        ApiConstants.appModules,
        methodType: MethodType.get,
        parser: (json) {
          bool isSuccess = false;
          if (json is Map<String, dynamic>) {
            final successVal = json['success'];
            if (successVal is bool)
              isSuccess = successVal;
            else if (successVal is String)
              isSuccess = successVal.toLowerCase() == 'true';
            else if (successVal is int)
              isSuccess = successVal == 1;
          }

          if (isSuccess && json['data'] != null) {
            return ModuleConfig.fromJson(json['data']);
          }
          return null;
        },
      );
    } catch (e) {
      // Allow provider to handle null/error or log here
      return null;
    }
  }
}
