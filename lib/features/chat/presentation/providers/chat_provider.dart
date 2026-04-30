import 'package:flutter/material.dart';
import '../../data/models/chat_room_model.dart';
import '../../data/models/chat_message_model.dart';
import 'package:exim_lab/core/services/shared_pref_service.dart';
import 'package:exim_lab/core/services/socket_service.dart';
import 'dart:async';
import 'package:exim_lab/core/services/audio_service.dart';

class ChatProvider extends ChangeNotifier {
  final SocketService _socketService = SocketService();
  final SharedPrefService _prefs = SharedPrefService();
  final AudioService _audioService = AudioService();
  
  dynamic _activeRoomId;
  String? _nextCursor;
  bool _hasMore = true;
  bool _isFetchingMore = false;

  final List<ChatRoom> _rooms = [];
  final Map<dynamic, List<ChatMessage>> _messagesByRoom = {};
  final Map<dynamic, int> _unreadCounts = {};

  bool _isLoading = false;
  bool _isSending = false;
  bool _isJoining = false;
  dynamic _joiningRoomId;
  String? _error;

  List<ChatRoom> get rooms => _rooms;
  List<ChatMessage> get messages => _messagesByRoom[_activeRoomId] ?? [];
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  bool get isJoining => _isJoining;
  dynamic get joiningRoomId => _joiningRoomId;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;
  int getUnreadCount(dynamic roomId) => _unreadCounts[roomId] ?? 0;

  ChatProvider() {
    _initSocket();
  }

  Future<void> _initSocket() async {
    await _socketService.init();
    
    // Listen for new messages
    _socketService.on('message:new', (payload) {
      final roomId = payload['roomId'];
      final messageData = payload['data'];
      
      _handleIncomingMessage(roomId, messageData);
    });

    // Initial fetch of rooms
    fetchRooms();
  }

  void _handleIncomingMessage(dynamic roomId, Map<String, dynamic> data) async {
    final user = await _prefs.getUser();
    final currentUserId = user?.id ?? '';
    final newMessage = ChatMessage.fromJson(data, currentUserId);

    if (_messagesByRoom.containsKey(roomId)) {
      // Append only if it doesn't exist (avoid duplicates if send ack also adds it)
      final exists = _messagesByRoom[roomId]!.any((m) => m.id == newMessage.id);
      if (!exists) {
        _messagesByRoom[roomId]!.insert(0, newMessage);
        
        // Play sound if it's not my own message
        if (!newMessage.isMe) {
          _audioService.playNotificationSound();
        }
      }
    }

    if (roomId != _activeRoomId) {
      _unreadCounts[roomId] = (_unreadCounts[roomId] ?? 0) + 1;
    }

    notifyListeners();
  }

  Future<void> fetchRooms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _socketService.emit('rooms:list', {}, (response) {
      if (response['success'] == true) {
        final List data = response['data'];
        _rooms.clear();
        _rooms.addAll(data.map((json) => ChatRoom.fromJson(json)).toList());
      } else {
        _error = response['message'] ?? "Failed to fetch rooms";
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> fetchMessages(dynamic roomId, {bool isRefresh = false}) async {
    _activeRoomId = roomId;
    _unreadCounts[roomId] = 0; // Clear unread on enter

    if (!isRefresh || !(_messagesByRoom.containsKey(roomId))) {
      _isLoading = true;
      _nextCursor = null;
      _hasMore = true;
    }

    _error = null;
    notifyListeners();

    final payload = {
      'roomId': roomId,
      'limit': 50,
      'cursor': null,
    };

    _socketService.emit('messages:fetch', payload, (response) async {
      if (response['success'] == true) {
        final user = await _prefs.getUser();
        final currentUserId = user?.id ?? '';
        final List data = response['data'];
        final List<ChatMessage> fetchedMessages = data.map((json) => ChatMessage.fromJson(json, currentUserId)).toList();
        
        // Backend returns OLD -> NEW, but UI expects NEW -> OLD (index 0 is newest)
        _messagesByRoom[roomId] = fetchedMessages.reversed.toList();
        
        _nextCursor = response['meta']['nextCursor'];
        _hasMore = _nextCursor != null;
      } else {
        _error = response['message'] ?? "Failed to fetch messages";
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> loadMoreMessages() async {
    if (_isFetchingMore || !_hasMore || _nextCursor == null || _activeRoomId == null) return;

    _isFetchingMore = true;
    notifyListeners();

    final payload = {
      'roomId': _activeRoomId,
      'limit': 50,
      'cursor': _nextCursor,
    };

    _socketService.emit('messages:fetch', payload, (response) async {
      if (response['success'] == true) {
        final user = await _prefs.getUser();
        final currentUserId = user?.id ?? '';
        final List data = response['data'];
        final List<ChatMessage> olderMessages = data.map((json) => ChatMessage.fromJson(json, currentUserId)).toList();
        
        // Prepend to the items (which means append to our list since index 0 is newest)
        // Wait, if index 0 is newest, older messages should go at the end.
        _messagesByRoom[_activeRoomId]!.addAll(olderMessages.reversed);
        
        _nextCursor = response['meta']['nextCursor'];
        _hasMore = _nextCursor != null;
      }
      _isFetchingMore = false;
      notifyListeners();
    });
  }

  Future<bool> sendMessage(dynamic roomId, String text) async {
    if (text.trim().isEmpty) return false;

    if (RegExp(r'[0-9]').hasMatch(text)) {
      _error = "Numbers are not allowed in chat messages";
      notifyListeners();
      return false;
    }

    _isSending = true;
    notifyListeners();

    final payload = {
      'roomId': roomId,
      'message': text,
    };

    final completer = Completer<bool>();

    _socketService.emit('message:send', payload, (response) async {
      if (response['success'] == true) {
        final user = await _prefs.getUser();
        final currentUserId = user?.id ?? '';
        final messageData = response['data'];
        final sentMessage = ChatMessage.fromJson(messageData, currentUserId);
        
        // Optimistic check: if not already added by 'message:new'
        if (_messagesByRoom.containsKey(roomId)) {
          final exists = _messagesByRoom[roomId]!.any((m) => m.id == sentMessage.id);
          if (!exists) {
            _messagesByRoom[roomId]!.insert(0, sentMessage);
          }
        }
        
        _audioService.playSendMessageSound();
        completer.complete(true);
      } else {
        _error = response['message'] ?? "Failed to send message";
        completer.complete(false);
      }
      _isSending = false;
      notifyListeners();
    });

    return completer.future;
  }

  Future<bool> joinRoom(dynamic roomId) async {
    _isJoining = true;
    _joiningRoomId = roomId;
    _error = null;
    notifyListeners();

    final completer = Completer<bool>();

    _socketService.emit('room:join', {'roomId': roomId}, (response) {
      if (response['success'] == true) {
        final index = _rooms.indexWhere((r) => r.id == roomId);
        if (index != -1) {
          _rooms[index] = ChatRoom(
            id: _rooms[index].id,
            name: _rooms[index].name,
            description: _rooms[index].description,
            category: _rooms[index].category,
            isActive: _rooms[index].isActive,
            memberCount: _rooms[index].memberCount + 1,
            isJoined: true,
            joinedAt: DateTime.now(),
          );
        }
        fetchMessages(roomId);
        completer.complete(true);
      } else {
        _error = response['message'] ?? "Failed to join room";
        completer.complete(false);
      }
      _isJoining = false;
      _joiningRoomId = null;
      notifyListeners();
    });

    return completer.future;
  }
}
