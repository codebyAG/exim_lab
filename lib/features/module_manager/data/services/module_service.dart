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
          if (json is Map<String, dynamic> && json['success'] == true) {
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
