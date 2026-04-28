import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import '../models/chat_room_model.dart';
import '../models/chat_message_model.dart';

class ChatRemoteDataSource {
  Future<List<ChatRoom>> getChatRooms() async {
    return await callApi(
      ApiConstants.chatRooms,
      parser: (json) {
        final List roomsData = json['data'] ?? [];
        return roomsData.map((r) => ChatRoom.fromJson(r)).toList();
      },
    );
  }

  Future<List<ChatMessage>> getChatMessages(int roomId, String currentUserId) async {
    return await callApi(
      ApiConstants.chatMessages(roomId),
      parser: (json) {
        final List messagesData = json['data'] ?? [];
        return messagesData.map((m) => ChatMessage.fromJson(m, currentUserId)).toList();
      },
    );
  }

  Future<ChatMessage?> sendMessage(int roomId, String message, String currentUserId) async {
    return await callApi(
      ApiConstants.chatSendMessage,
      methodType: MethodType.post,
      requestData: {
        'roomId': roomId,
        'message': message,
      },
      parser: (json) {
        if (json['success'] == true && json['data'] != null) {
          return ChatMessage.fromJson(json['data'], currentUserId);
        }
        return null;
      },
    );
  }
}

class ChatRepository {
  final ChatRemoteDataSource _dataSource = ChatRemoteDataSource();

  Future<List<ChatRoom>> getChatRooms() => _dataSource.getChatRooms();
  Future<List<ChatMessage>> getChatMessages(int roomId, String currentUserId) => 
      _dataSource.getChatMessages(roomId, currentUserId);
  Future<ChatMessage?> sendMessage(int roomId, String message, String currentUserId) => 
      _dataSource.sendMessage(roomId, message, currentUserId);
}
