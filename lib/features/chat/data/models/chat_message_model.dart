class ChatMessage {
  final dynamic id;
  final dynamic roomId;
  final String senderId;
  final String senderName;
  final String senderImageUrl;
  final String message;
  final DateTime createdAt;
  final bool isMe;

  final bool isAdmin;

  ChatMessage({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderName,
    required this.senderImageUrl,
    required this.message,
    required this.createdAt,
    this.isMe = false,
    this.isAdmin = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, String currentUserId) {
    return ChatMessage(
      id: json['messageId'] ?? json['id'] ?? 0,
      roomId: json['roomId'] ?? 0,
      senderId: json['senderId']?.toString() ?? '',
      senderName: json['senderName'] ?? (json['isAdmin'] == true ? 'Admin' : 'User'),
      senderImageUrl: json['senderImageUrl'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['timestamp'] ?? json['createdAt'] ?? DateTime.now().toIso8601String()),
      isMe: (json['senderId']?.toString() ?? '') == currentUserId,
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'senderId': senderId,
      'senderName': senderName,
      'senderImageUrl': senderImageUrl,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
