class CourseDetailsModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final int basePrice;
  final List<LessonModel> lessons;

  CourseDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.basePrice,
    required this.lessons,
    this.imageUrl,
  });

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailsModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json["imageUrl"],
      basePrice: json['basePrice'] ?? 0,
      lessons: (json['lessons'] as List)
          .map((e) => LessonModel.fromJson(e))
          .toList(),
    );
  }
}

class LessonModel {
  final String id;
  final String chapterTitle;
  final int chapterOrder;
  final String title;
  final String type;
  final String contentUrl;
  final int order;

  LessonModel({
    required this.id,
    required this.chapterTitle,
    required this.chapterOrder,
    required this.title,
    required this.type,
    required this.contentUrl,
    required this.order,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['_id'],
      chapterTitle: json['chapterTitle'],
      chapterOrder: json['chapterOrder'],
      title: json['title'],
      type: json['type'],
      contentUrl: json['contentUrl'],
      order: json['order'],
    );
  }
}
