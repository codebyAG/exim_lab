import 'package:flutter/material.dart';

enum ChatCategory {
  import,
  export,
  logistics,
  finance,
  market,
  general
}

class ChatRoom {
  final dynamic id;
  final String name;
  final String description;
  final ChatCategory category;
  final bool isActive;
  final int memberCount;

  ChatRoom({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.isActive = true,
    this.memberCount = 0,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['roomId'] ?? json['id'] ?? json['_id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: _parseCategory(json['category'] ?? json['slug']),
      isActive: json['isActive'] ?? true,
      memberCount: json['memberCount'] ?? 0,
    );
  }

  static ChatCategory _parseCategory(String? cat) {
    switch (cat?.toUpperCase()) {
      case 'IMPORT': return ChatCategory.import;
      case 'EXPORT': return ChatCategory.export;
      case 'LOGISTICS': return ChatCategory.logistics;
      case 'FINANCE': return ChatCategory.finance;
      case 'MARKET': return ChatCategory.market;
      default: return ChatCategory.general;
    }
  }

  IconData get icon {
    switch (category) {
      case ChatCategory.import: return Icons.download_rounded;
      case ChatCategory.export: return Icons.upload_rounded;
      case ChatCategory.logistics: return Icons.local_shipping_rounded;
      case ChatCategory.finance: return Icons.account_balance_rounded;
      case ChatCategory.market: return Icons.trending_up_rounded;
      case ChatCategory.general: return Icons.forum_rounded;
    }
  }

  Color get color {
    switch (category) {
      case ChatCategory.import: return const Color(0xFF1E5FFF);
      case ChatCategory.export: return const Color(0xFFFF8800);
      case ChatCategory.logistics: return const Color(0xFF00C853);
      case ChatCategory.finance: return const Color(0xFF6200EA);
      case ChatCategory.market: return const Color(0xFFFFD600);
      case ChatCategory.general: return const Color(0xFF757575);
    }
  }
}
