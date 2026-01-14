import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';

class AiChatRemote {
  Future<String> sendMessage(String message) async {
    return callApi<String>(
      ApiConstants.aiChat, 
      methodType: MethodType.post,
      requestData: {
        "message": message,
      },
      parser: (json) {
        return json['reply'] ?? '';
      },
    );
  }
}
