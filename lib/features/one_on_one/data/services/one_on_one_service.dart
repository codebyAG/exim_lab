import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/one_on_one/data/models/one_on_one_config_model.dart';

class OneOnOneService {
  /// GET /api/one-on-one/config — the whole page in one call.
  Future<OneOnOneConfig> fetchConfig() async {
    return callApi<OneOnOneConfig>(
      ApiConstants.oneOnOneConfig,
      methodType: MethodType.get,
      parser: (json) {
        final data = json is Map ? json['data'] : null;
        if (data is! Map) {
          throw Exception('Malformed one-on-one config response');
        }
        return OneOnOneConfig.fromJson(Map<String, dynamic>.from(data));
      },
    );
  }
}
