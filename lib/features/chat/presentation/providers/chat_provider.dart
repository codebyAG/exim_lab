import 'package:flutter/material.dart';
import '../../data/models/chat_room_model.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/repositories/chat_repository.dart';
import 'package:exim_lab/core/services/shared_pref_service.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:exim_lab/core/services/audio_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _repository = ChatRepository();
  final SharedPrefService _prefs = SharedPrefService();
  final AudioService _audioService = AudioService();
  dynamic _activeRoomId;

  String? _nextCursor;
  bool _hasMore = true;
  bool _isFetchingMore = false;

  List<ChatRoom> _rooms = [];
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;
  String? _error;

  List<ChatRoom> get rooms => _rooms;
  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;

  Future<void> fetchRooms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _rooms = await _repository.getChatRooms();
    } catch (e) {
      _error = e.toString();
      developer.log("⚠️ Chat Rooms Fetch Error: $e", name: "CHAT");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMessages(dynamic roomId, {bool isRefresh = false}) async {
    _activeRoomId = roomId;

    // Only clear and show full loader if not a quiet refresh or if we have no messages
    if (!isRefresh || _messages.isEmpty) {
      _messages = [];
      _isLoading = true;
      _nextCursor = null;
      _hasMore = true;
      _isFetchingMore = false;
    }

    _error = null;
    notifyListeners();

    try {
      final user = await _prefs.getUser();
      final currentUserId = user?.id ?? '';
      final result = await _repository.getChatMessages(roomId, currentUserId);

      // Update messages silently
      _messages = result['messages'];
      _sortMessages();

      // Update cursor only if we were at the top (refreshing)
      if (!isRefresh) {
        _nextCursor = result['nextCursor'];
        _hasMore = _nextCursor != null;
      }
    } catch (e) {
      _error = e.toString();
      developer.log("⚠️ Chat Messages Fetch Error: $e", name: "CHAT");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreMessages() async {
    if (_isFetchingMore ||
        !_hasMore ||
        _nextCursor == null ||
        _activeRoomId == null)
      return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      final user = await _prefs.getUser();
      final currentUserId = user?.id ?? '';
      final result = await _repository.getChatMessages(
        _activeRoomId,
        currentUserId,
        cursor: _nextCursor,
      );

      final List<ChatMessage> olderMessages = result['messages'];
      // Append older history at the end of the list and re-sort
      _messages.addAll(olderMessages);
      _sortMessages();

      _nextCursor = result['nextCursor'];
      _hasMore = _nextCursor != null;
    } catch (e) {
      developer.log("⚠️ Pagination Error: $e", name: "CHAT");
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  void _sortMessages() {
    _messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<bool> sendMessage(dynamic roomId, String text) async {
    if (text.trim().isEmpty) return false;

    // 🛡️ Block messages containing numbers
    if (RegExp(r'[0-9]').hasMatch(text)) {
      _error = "Numbers are not allowed in chat messages";
      notifyListeners();
      return false;
    }

    try {
      final user = await _prefs.getUser();
      final currentUserId = user?.id ?? '';

      // 🚀 OPTIMISTIC UI: Show message immediately
      final tempMessage = ChatMessage(
        id: "temp_${DateTime.now().millisecondsSinceEpoch}",
        roomId: roomId,
        senderId: currentUserId,
        senderName: user?.name ?? "Me",
        senderImageUrl: user?.avatarUrl ?? "",
        message: text,
        createdAt: DateTime.now(),
        isMe: true,
      );

      _messages.insert(0, tempMessage);
      _audioService.playSendMessageSound(); // 🔊 Play sound immediately
      notifyListeners();

      final newMessage = await _repository.sendMessage(
        roomId,
        text,
        currentUserId,
      );

      if (newMessage != null) {
        // 🚀 Silent Refresh: Fetch the latest thread to catch other people's messages too
        // We do this immediately to ensure UI is perfectly up-to-date without flicker
        unawaited(fetchMessages(roomId, isRefresh: true));
        return true;
      } else {
        // If failed, remove the temp message
        _messages.removeWhere((m) => m.id == tempMessage.id);
        notifyListeners();
        return false;
      }
    } catch (e) {
      developer.log("⚠️ Send Message Error: $e", name: "CHAT");
      return false;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }
}
