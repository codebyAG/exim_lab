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

  Future<Map<String, dynamic>> getChatMessages(dynamic roomId, String currentUserId, {String? cursor}) async {
    return await callApi(
      ApiConstants.chatMessages(roomId, cursor: cursor),
      parser: (json) {
        final List messagesData = json['data'] ?? [];
        final messages = messagesData.map((m) => ChatMessage.fromJson(m, currentUserId)).toList();
        final nextCursor = json['meta']?['nextCursor'];
        return {
          'messages': messages,
          'nextCursor': nextCursor,
        };
      },
    );
  }

  Future<ChatMessage?> sendMessage(dynamic roomId, String message, String currentUserId) async {
    return await callApi(
      ApiConstants.chatSendMessage(roomId),
      methodType: MethodType.post,
      requestData: {
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
  Future<Map<String, dynamic>> getChatMessages(dynamic roomId, String currentUserId, {String? cursor}) => 
      _dataSource.getChatMessages(roomId, currentUserId, cursor: cursor);
  Future<ChatMessage?> sendMessage(dynamic roomId, String message, String currentUserId) => 
      _dataSource.sendMessage(roomId, message, currentUserId);
}
