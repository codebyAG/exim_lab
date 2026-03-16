class UserModel {
  final String id;
  final String? name;
  final String mobile;
  final String role;
  final String organizationId;
  final String? email;
  final String? avatarUrl;
  final bool isPremium;
  final String? interestedIn;
  final UserStats? stats;

  UserModel({
    required this.id,
    this.name,
    required this.mobile,
    required this.role,
    required this.organizationId,
    this.email,
    this.avatarUrl,
    this.isPremium = false,
    this.interestedIn,
    this.stats,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'],
      mobile: json['mobile'] ?? '',
      role: json['role'] ?? 'USER',
      organizationId: json['organizationId'] ?? '',
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      isPremium: json['isPremium'] ?? false,
      interestedIn: json['interestedIn'] ?? json['interest'],
      stats: json['stats'] != null ? UserStats.fromJson(json['stats']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'mobile': mobile,
      'role': role,
      'organizationId': organizationId,
      'email': email,
      'avatarUrl': avatarUrl,
      'isPremium': isPremium,
      'interestedIn': interestedIn,
      'stats': stats?.toJson(),
    };
  }
}

class UserStats {
  final int activeCourses;
  final int completedCourses;
  final int totalCourses;
  final int learningStreak;
  final int quizzesTaken;

  UserStats({
    this.activeCourses = 0,
    this.completedCourses = 0,
    this.totalCourses = 0,
    this.learningStreak = 0,
    this.quizzesTaken = 0,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      activeCourses: json['activeCourses'] ?? 0,
      completedCourses: json['completedCourses'] ?? 0,
      totalCourses: json['totalCourses'] ?? 0,
      learningStreak: json['learningStreak'] ?? 0,
      quizzesTaken: json['quizzesTaken'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeCourses': activeCourses,
      'completedCourses': completedCourses,
      'totalCourses': totalCourses,
      'learningStreak': learningStreak,
      'quizzesTaken': quizzesTaken,
    };
  }
}
