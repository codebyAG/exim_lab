import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/premium/data/models/premium_config_model.dart';

class PremiumService {
  /// GET /api/premium-features/config — the whole page in one call.
  Future<PremiumConfig> fetchConfig() async {
    return callApi<PremiumConfig>(
      ApiConstants.premiumFeaturesConfig,
      methodType: MethodType.get,
      parser: (json) {
        final data = json is Map ? json['data'] : null;
        if (data is! Map) {
          throw Exception('Malformed premium config response');
        }
        return PremiumConfig.fromJson(Map<String, dynamic>.from(data));
      },
    );
  }
}
