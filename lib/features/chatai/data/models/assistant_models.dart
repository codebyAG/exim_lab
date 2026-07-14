// Models for the Import/Export AI Assistant (/api/assistant).

class AssistantStarter {
  final String id;
  final String text;
  final int order;

  AssistantStarter({required this.id, required this.text, required this.order});

  factory AssistantStarter.fromJson(Map<String, dynamic> json) {
    return AssistantStarter(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      text: json['text'] ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
    );
  }
}

class StartersData {
  final List<AssistantStarter> starters;
  final bool hasOldChats;
  final int oldChatsCount;

  StartersData({
    required this.starters,
    required this.hasOldChats,
    required this.oldChatsCount,
  });

  factory StartersData.fromJson(Map<String, dynamic> json) {
    return StartersData(
      starters: (json['starters'] as List? ?? [])
          .map((e) => AssistantStarter.fromJson(e))
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order)),
      hasOldChats: json['hasOldChats'] ?? false,
      oldChatsCount: (json['oldChatsCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class AssistantMessage {
  final String id;
  final String role; // 'user' | 'assistant'
  final String content;
  final DateTime? createdAt;

  AssistantMessage({
    required this.id,
    required this.role,
    required this.content,
    this.createdAt,
  });

  bool get isUser => role == 'user';

  factory AssistantMessage.fromJson(Map<String, dynamic> json) {
    return AssistantMessage(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      role: json['role'] ?? 'assistant',
      content: json['content'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
    );
  }
}

class AssistantConversation {
  final String id;
  final String title;
  final String lastMessagePreview;
  final DateTime? lastMessageAt;
  final int messageCount;

  AssistantConversation({
    required this.id,
    required this.title,
    required this.lastMessagePreview,
    this.lastMessageAt,
    required this.messageCount,
  });

  factory AssistantConversation.fromJson(Map<String, dynamic> json) {
    return AssistantConversation(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title'] ?? 'Chat',
      lastMessagePreview: json['lastMessagePreview'] ?? '',
      lastMessageAt: DateTime.tryParse(json['lastMessageAt'] ?? ''),
      messageCount: (json['messageCount'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Response of POST /api/assistant/chat
class AssistantChatResult {
  final String conversationId;
  final AssistantMessage userMessage;
  final AssistantMessage assistantMessage;

  AssistantChatResult({
    required this.conversationId,
    required this.userMessage,
    required this.assistantMessage,
  });

  factory AssistantChatResult.fromJson(Map<String, dynamic> json) {
    return AssistantChatResult(
      conversationId: json['conversationId']?.toString() ?? '',
      userMessage: AssistantMessage.fromJson(json['userMessage'] ?? {}),
      assistantMessage:
          AssistantMessage.fromJson(json['assistantMessage'] ?? {}),
    );
  }
}

/// Response of GET /api/assistant/conversations/:id
class ConversationDetail {
  final AssistantConversation conversation;
  final List<AssistantMessage> messages;

  ConversationDetail({required this.conversation, required this.messages});

  factory ConversationDetail.fromJson(Map<String, dynamic> json) {
    return ConversationDetail(
      conversation:
          AssistantConversation.fromJson(json['conversation'] ?? {}),
      messages: (json['messages'] as List? ?? [])
          .map((e) => AssistantMessage.fromJson(e))
          .toList(),
    );
  }
}
