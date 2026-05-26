import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/core/models/social_links_model.dart';
import 'package:exim_lab/core/models/live_event_config_model.dart';

class ConfigService {
  Future<SocialLinks?> fetchSocialLinks() async {
    return await callApi(
      ApiConstants.socialLinks,
      parser: (json) {
        if (json['success'] == true && json['data'] != null) {
          return SocialLinks.fromJson(json['data']);
        }
        return null;
      },
    );
  }

  Future<LiveEventConfig?> fetchLiveEventConfig() async {
    return await callApi(
      ApiConstants.seminarHome,
      parser: (json) {
        if (json['success'] == true && json['data'] != null) {
          return LiveEventConfig.fromJson(json['data']);
        }
        return null;
      },
    );
  }

  Future<bool> fetchMaintenanceStatus() async {
    return true; // Mocked: Force maintenance mode for visual verification
    try {
      return await callApi(
        ApiConstants.maintenance,
        parser: (json) {
          if (json is Map<String, dynamic>) {
            // Check 'maintenance' key at top-level
            if (json.containsKey('maintenance')) {
              final val = json['maintenance'];
              if (val is bool) return val;
              if (val is String) return val.toLowerCase() == 'true';
              if (val is int) return val == 1;
            }
            // Check inside 'data' if present
            final data = json['data'];
            if (data is Map<String, dynamic> && data.containsKey('maintenance')) {
              final val = data['maintenance'];
              if (val is bool) return val;
              if (val is String) return val.toLowerCase() == 'true';
              if (val is int) return val == 1;
            }
          }
          return false;
        },
        logErrorEvent: false,
      );
    } catch (_) {
      return false;
    }
  }
}
