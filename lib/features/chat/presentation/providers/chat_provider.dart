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
  bool _isLoadingMore = false;

  List<ChatRoom> _rooms = [];
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;
  String? _error;

  List<ChatRoom> get rooms => _rooms;
  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  bool get isLoadingMore => _isLoadingMore;
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

  Future<void> fetchMessages(dynamic roomId) async {
    _activeRoomId = roomId;
    _messages = []; // 🛡️ Clear old messages immediately
    _isLoading = true; // Always show loader for new room
    _error = null;
    _nextCursor = null;
    _hasMore = true;
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
    if (_isLoadingMore || !_hasMore || _activeRoomId == null) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final user = await _prefs.getUser();
      final currentUserId = user?.id ?? '';
      final result = await _repository.getChatMessages(
        _activeRoomId, 
        currentUserId, 
        cursor: _nextCursor
      );
      
      final List<ChatMessage> newMessages = result['messages'];
      // Prepend old messages (pagination usually goes backwards in time for chat)
      _messages.insertAll(0, newMessages);
      _nextCursor = result['nextCursor'];
      _hasMore = _nextCursor != null;
    } catch (e) {
      developer.log("⚠️ Chat Load More Error: $e", name: "CHAT");
    } finally {
      _isLoadingMore = false;
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
        // Option 1: Just add the message (fast)
        // Option 2: Re-fetch (Safe & Syncs with server timestamps/IDs)
        await fetchMessages(roomId);
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
