import 'package:flutter/material.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/chatai/data/models/assistant_models.dart';
import 'package:exim_lab/features/chatai/data/services/assistant_service.dart';

/// State for the AI Assistant (ChatGPT-style new chat + WhatsApp history).
class AssistantProvider extends ChangeNotifier {
  final AssistantService _service = AssistantService();

  // ── New-chat screen ──
  List<AssistantStarter> starters = [];
  bool hasOldChats = false;
  int oldChatsCount = 0;
  bool loadingStarters = false;

  // ── Active thread ──
  final List<AssistantMessage> messages = [];
  String? activeConversationId;
  bool sending = false;
  bool loadingThread = false;

  // ── Old chats list ──
  List<AssistantConversation> conversations = [];
  bool loadingConversations = false;

  /// Last failed message text — used by the Retry action.
  String? lastFailedText;

  bool get isNewChat => messages.isEmpty && activeConversationId == null;

  /// Load starters + history flag (call when the assistant opens).
  Future<void> init() async {
    loadingStarters = true;
    notifyListeners();
    try {
      final data = await _service.getStarters();
      starters = data.starters;
      hasOldChats = data.hasOldChats;
      oldChatsCount = data.oldChatsCount;
    } catch (_) {
      // Starters are non-critical — user can still type a message.
      starters = [];
    } finally {
      loadingStarters = false;
      notifyListeners();
    }
  }

  /// Send a message. First send of a session omits conversationId; the id
  /// from the response is stored and used for every later send.
  /// Returns an error string to show, or null on success.
  Future<String?> send(String text) async {
    final message = text.trim();
    if (message.isEmpty || sending) return null;

    // Optimistic user bubble
    final optimistic = AssistantMessage(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      role: 'user',
      content: message,
      createdAt: DateTime.now(),
    );
    messages.add(optimistic);
    sending = true;
    lastFailedText = null;
    notifyListeners();

    try {
      final result = await _service.sendMessage(
        message: message,
        conversationId: activeConversationId,
      );

      activeConversationId = result.conversationId;

      // Replace the optimistic bubble with the server's copy, then append
      // the assistant reply.
      messages.remove(optimistic);
      messages.add(result.userMessage);
      messages.add(result.assistantMessage);
      hasOldChats = true;
      return null;
    } catch (e) {
      // Keep the user's bubble; remember the text for Retry.
      lastFailedText = message;
      messages.remove(optimistic);
      return _errorMessage(e);
    } finally {
      sending = false;
      notifyListeners();
    }
  }

  String _errorMessage(Object e) {
    if (e is ApiException) {
      if (e.statusCode == 503) {
        return 'AI assistant is not available right now. Please try later.';
      }
      if (e.statusCode == 502) {
        return 'AI service failed to respond. Please retry.';
      }
      return e.message;
    }
    return 'Something went wrong. Please retry.';
  }

  /// Load the old-chats list (WhatsApp style).
  Future<void> loadConversations() async {
    loadingConversations = true;
    notifyListeners();
    try {
      conversations = await _service.getConversations(page: 1, limit: 50);
    } catch (_) {
      conversations = [];
    } finally {
      loadingConversations = false;
      notifyListeners();
    }
  }

  /// Open an old conversation as the active thread.
  Future<bool> openConversation(String conversationId) async {
    loadingThread = true;
    messages.clear();
    activeConversationId = conversationId;
    notifyListeners();
    try {
      final detail = await _service.getConversation(conversationId);
      messages
        ..clear()
        ..addAll(detail.messages);
      activeConversationId = detail.conversation.id.isNotEmpty
          ? detail.conversation.id
          : conversationId;
      return true;
    } catch (_) {
      return false;
    } finally {
      loadingThread = false;
      notifyListeners();
    }
  }

  /// Back to a fresh empty thread (starters visible again).
  void startNewChat() {
    messages.clear();
    activeConversationId = null;
    lastFailedText = null;
    notifyListeners();
  }
}
