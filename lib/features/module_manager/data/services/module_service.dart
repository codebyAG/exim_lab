import 'dart:convert';
import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/module_manager/data/models/module_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModuleService {
  static const String _storageKey = 'module_config_cache';

  Future<ModuleConfig?> fetchConfig() async {
    try {
      final config = await callApi<ModuleConfig?>(
        ApiConstants.appModules,
        methodType: MethodType.get,
        parser: (json) {
          bool isSuccess = false;
          if (json is Map<String, dynamic>) {
            final successVal = json['success'];
            if (successVal is bool) {
              isSuccess = successVal;
            } else if (successVal is String) {
              isSuccess = successVal.toLowerCase() == 'true';
            } else if (successVal is int) {
              isSuccess = successVal == 1;
            }
          }

          if (isSuccess && json['data'] != null) {
            return ModuleConfig.fromJson(json['data']);
          }
          return null;
        },
      );

      if (config != null) {
        await _saveLocalConfig(config);
      }
      return config;
    } catch (e) {
      // If API fails, try to return local config if available, OR just return null
      // The provider will handle the fallback logic
      return null;
    }
  }

  Future<void> _saveLocalConfig(ModuleConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(config.toJson()));
    } catch (e) {
      // Ignore cache save errors
    }
  }

  Future<ModuleConfig?> getLocalConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        return ModuleConfig.fromJson(jsonDecode(jsonString));
      }
    } catch (e) {
      // Ignore cache load errors
    }
    return null;
  }
}
