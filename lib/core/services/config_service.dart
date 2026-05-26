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
}
