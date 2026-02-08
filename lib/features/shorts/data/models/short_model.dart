class ShortModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final int durationSeconds;
  final int viewCount;
  final int likeCount;
  final bool metadataFetched;

  ShortModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.durationSeconds,
    this.viewCount = 0,
    this.likeCount = 0,
    this.metadataFetched = false,
  });

  factory ShortModel.fromJson(Map<String, dynamic> json) {
    return ShortModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      durationSeconds: json['durationSeconds'] ?? 0,
    );
  }

  ShortModel copyWith({
    String? title,
    String? description,
    String? thumbnailUrl,
    int? viewCount,
    int? likeCount,
    bool? metadataFetched,
  }) {
    return ShortModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      durationSeconds: durationSeconds,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      metadataFetched: metadataFetched ?? this.metadataFetched,
    );
  }
}
