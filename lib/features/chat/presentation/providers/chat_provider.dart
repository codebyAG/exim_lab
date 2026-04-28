import 'package:flutter/material.dart';
import '../../data/models/chat_room_model.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/repositories/chat_repository.dart';
import 'package:exim_lab/core/services/shared_pref_service.dart';
import 'dart:developer' as developer;
import 'dart:async';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _repository = ChatRepository();
  final SharedPrefService _prefs = SharedPrefService();
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
    }

    _error = null;
    _nextCursor = null;
    _hasMore = true;
    _isFetchingMore = false;
    notifyListeners();

    try {
      final user = await _prefs.getUser();
      final currentUserId = user?.id ?? '';
      final result = await _repository.getChatMessages(roomId, currentUserId);
      _messages = result['messages'];
      _nextCursor = result['nextCursor'];
      _hasMore = _nextCursor != null;
    } catch (e) {
      _error = e.toString();
      developer.log("⚠️ Chat Messages Fetch Error: $e", name: "CHAT");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreMessages() async {
    if (_isFetchingMore || !_hasMore || _nextCursor == null || _activeRoomId == null) return;

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
      // Append older history at the end of the list
      _messages.addAll(olderMessages);
      
      _nextCursor = result['nextCursor'];
      _hasMore = _nextCursor != null;
    } catch (e) {
      developer.log("⚠️ Pagination Error: $e", name: "CHAT");
    } finally {
      _isFetchingMore = false;
      notifyListeners();
    }
  }


  Future<bool> sendMessage(dynamic roomId, String text) async {
    if (text.trim().isEmpty) return false;
    _isSending = true;
    notifyListeners();

    try {
      final user = await _prefs.getUser();
      final currentUserId = user?.id ?? '';
      final newMessage = await _repository.sendMessage(roomId, text, currentUserId);
      if (newMessage != null) {
        // Add new message at index 0 (bottom of the reversed list)
        _messages.insert(0, newMessage);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      developer.log("⚠️ Send Message Error: $e", name: "CHAT");
      return false;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }
}
