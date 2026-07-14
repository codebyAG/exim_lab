import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/chatai/data/models/assistant_models.dart';

/// API client for the Import/Export AI Assistant.
/// Bearer token is attached automatically by [callApi].
class AssistantService {
  /// GET /api/assistant/starters
  Future<StartersData> getStarters() async {
    return callApi<StartersData>(
      ApiConstants.assistantStarters,
      methodType: MethodType.get,
      parser: (json) => StartersData.fromJson(json['data'] ?? {}),
    );
  }

  /// POST /api/assistant/chat — omit [conversationId] for a new chat.
  Future<AssistantChatResult> sendMessage({
    required String message,
    String? conversationId,
  }) async {
    return callApi<AssistantChatResult>(
      ApiConstants.assistantChat,
      methodType: MethodType.post,
      requestData: {
        'message': message,
        if (conversationId != null) 'conversationId': conversationId,
      },
      parser: (json) => AssistantChatResult.fromJson(json['data'] ?? {}),
    );
  }

  /// GET /api/assistant/conversations
  Future<List<AssistantConversation>> getConversations({
    int page = 1,
    int limit = 20,
  }) async {
    return callApi<List<AssistantConversation>>(
      ApiConstants.assistantConversations,
      methodType: MethodType.get,
      queryParameters: {'page': page, 'limit': limit},
      parser: (json) => (json['data'] as List? ?? [])
          .map((e) => AssistantConversation.fromJson(e))
          .toList(),
    );
  }

  /// GET /api/assistant/conversations/:id
  Future<ConversationDetail> getConversation(String conversationId) async {
    return callApi<ConversationDetail>(
      '${ApiConstants.assistantConversations}/$conversationId',
      methodType: MethodType.get,
      parser: (json) => ConversationDetail.fromJson(json['data'] ?? {}),
    );
  }
}
