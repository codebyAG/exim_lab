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
  Timer? _pollingTimer;
  int? _activeRoomId;

  List<ChatRoom> _rooms = [];
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;
  String? _error;

  List<ChatRoom> get rooms => _rooms;
  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
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

  Future<void> fetchMessages(int roomId) async {
    _activeRoomId = roomId;
    _isLoading = _messages.isEmpty; // Only show full loader if empty
    _error = null;
    notifyListeners();

    try {
      final user = await _prefs.getUser();
      final currentUserId = user?.id ?? '';
      _messages = await _repository.getChatMessages(roomId, currentUserId);
    } catch (e) {
      _error = e.toString();
      developer.log("⚠️ Chat Messages Fetch Error: $e", name: "CHAT");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startPollingMessages(int roomId) {
    stopPollingMessages(); // Clear existing
    _activeRoomId = roomId;
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_activeRoomId != null) {
        _quietFetchMessages(_activeRoomId!);
      }
    });
  }

  void stopPollingMessages() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _activeRoomId = null;
  }

  Future<void> _quietFetchMessages(int roomId) async {
    try {
      final user = await _prefs.getUser();
      final currentUserId = user?.id ?? '';
      final newMessages = await _repository.getChatMessages(roomId, currentUserId);
      
      // Update only if count changed to minimize UI rebuilds
      if (newMessages.length != _messages.length) {
        _messages = newMessages;
        notifyListeners();
      }
    } catch (e) {
      // Quiet fail for polling
    }
  }

  @override
  void dispose() {
    stopPollingMessages();
    super.dispose();
  }

  Future<bool> sendMessage(int roomId, String text) async {
    if (text.trim().isEmpty) return false;
    _isSending = true;
    notifyListeners();

    try {
      final user = await _prefs.getUser();
      final currentUserId = user?.id ?? '';
      final newMessage = await _repository.sendMessage(roomId, text, currentUserId);
      if (newMessage != null) {
        _messages.add(newMessage);
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
