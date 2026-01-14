import 'package:exim_lab/features/chatai/data/datasources/ai_chat_data_remote.dart';

class AiChatRepository {
  final AiChatRemote remote;

  AiChatRepository(this.remote);

  Future<String> askAi(String message) {
    return remote.sendMessage(message);
  }
}
