class FounderModel {
  final String name;
  final String designation;
  final String imageUrl;
  final String message;
  final String? videoUrl;

  FounderModel({
    required this.name,
    required this.designation,
    required this.imageUrl,
    required this.message,
    this.videoUrl,
  });

  factory FounderModel.fromJson(Map<String, dynamic> json) {
    return FounderModel(
      name: json['name'] ?? '',
      designation: json['designation'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      message: json['message'] ?? '',
      videoUrl: json['videoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'designation': designation,
      'imageUrl': imageUrl,
      'message': message,
      'videoUrl': videoUrl,
    };
  }
}
