import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import '../models/chat_room_model.dart';

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
}

class ChatRepository {
  final ChatRemoteDataSource _dataSource = ChatRemoteDataSource();

  Future<List<ChatRoom>> getChatRooms() => _dataSource.getChatRooms();
}
