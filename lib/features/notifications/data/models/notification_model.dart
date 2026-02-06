class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String source;
  final bool read;
  final String? linkUrl;
  final String? imageUrl;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.source,
    required this.read,
    this.linkUrl,
    this.imageUrl,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      source: json['source'] ?? '',
      read: json['read'] ?? false,
      linkUrl: json['linkUrl'],
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

class NotificationListResponse {
  final List<NotificationModel> data;
  final NotificationMeta meta;

  NotificationListResponse({required this.data, required this.meta});

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    return NotificationListResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => NotificationModel.fromJson(e))
              .toList() ??
          [],
      meta: json['meta'] != null
          ? NotificationMeta.fromJson(json['meta'])
          : NotificationMeta(page: 1, limit: 10, total: 0, totalPages: 1),
    );
  }
}

class NotificationMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  NotificationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory NotificationMeta.fromJson(Map<String, dynamic> json) {
    return NotificationMeta(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}
