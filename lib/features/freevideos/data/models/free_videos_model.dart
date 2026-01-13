class FreeVideoModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final int durationSeconds;

  FreeVideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.durationSeconds,
  });

  factory FreeVideoModel.fromJson(Map<String, dynamic> json) {
    return FreeVideoModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      videoUrl: json['videoUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      durationSeconds: json['durationSeconds'] ?? 0,
    );
  }
}
