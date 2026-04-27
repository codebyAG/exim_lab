import 'package:flutter/material.dart';
import '../../data/models/chat_room_model.dart';
import '../../data/repositories/chat_repository.dart';
import 'dart:developer' as developer;

class ChatProvider with ChangeNotifier {
  final ChatRepository _repository = ChatRepository();

  List<ChatRoom> _rooms = [];
  bool _isLoading = false;
  String? _error;

  List<ChatRoom> get rooms => _rooms;
  bool get isLoading => _isLoading;
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
}
