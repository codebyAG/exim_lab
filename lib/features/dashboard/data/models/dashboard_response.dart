import 'package:exim_lab/features/courses/data/models/course_model.dart';
import 'package:exim_lab/features/freevideos/data/models/free_videos_model.dart';

class DashboardResponse {
  final BannersData banners;
  final List<CourseModel> mostPopularCourses;
  final List<CourseModel> recommendedCourses;
  final List<CourseModel> continueCourses;
  final List<FreeVideoModel> freeVideos;
  final LiveSeminarModel? liveSeminar;
  final CourseOfTheDayModel? courseOfTheDay;

  DashboardResponse({
    required this.banners,
    required this.mostPopularCourses,
    required this.recommendedCourses,
    required this.continueCourses,
    required this.freeVideos,
    this.liveSeminar,
    this.courseOfTheDay,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      banners: BannersData.fromJson(json['banners'] ?? {}),
      mostPopularCourses:
          (json['mostPopularCourses'] as List?)
              ?.map((e) => CourseModel.fromJson(e))
              .toList() ??
          [],
      recommendedCourses:
          (json['recommendedCourses'] as List?)
              ?.map((e) => CourseModel.fromJson(e))
              .toList() ??
          [],
      continueCourses:
          (json['continueCourses'] as List?)
              ?.map((e) => CourseModel.fromJson(e))
              .toList() ??
          [],
      freeVideos:
          (json['freeVideos'] as List?)
              ?.map((e) => FreeVideoModel.fromJson(e))
              .toList() ??
          [],
      liveSeminar: json['liveSeminar'] != null
          ? LiveSeminarModel.fromJson(json['liveSeminar'])
          : null,
      courseOfTheDay: json['courseOfTheDay'] != null
          ? CourseOfTheDayModel.fromJson(json['courseOfTheDay'])
          : null,
    );
  }
}

class BannersData {
  final List<BannerModel> carousel;
  final List<BannerModel> inline;
  final BannerModel? popup;

  BannersData({required this.carousel, required this.inline, this.popup});

  factory BannersData.fromJson(Map<String, dynamic> json) {
    return BannersData(
      carousel:
          (json['carousel'] as List?)
              ?.map((e) => BannerModel.fromJson(e))
              .toList() ??
          [],
      inline:
          (json['inline'] as List?)
              ?.map((e) => BannerModel.fromJson(e))
              .toList() ??
          [],
      popup: json['popup'] != null ? BannerModel.fromJson(json['popup']) : null,
    );
  }
}

class BannerModel {
  final String title;
  final String description;
  final String imageUrl;
  final String ctaText;
  final String ctaUrl;
  final bool isActive;

  BannerModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ctaText,
    required this.ctaUrl,
    required this.isActive,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      ctaText: json['ctaText'] ?? '',
      ctaUrl: json['ctaUrl'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}

class LiveSeminarModel {
  final String title;
  final String subtitle;
  final String dateTime;
  final String meetingUrl;

  LiveSeminarModel({
    required this.title,
    required this.subtitle,
    required this.dateTime,
    required this.meetingUrl,
  });

  factory LiveSeminarModel.fromJson(Map<String, dynamic> json) {
    return LiveSeminarModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      dateTime: json['dateTime'] ?? '',
      meetingUrl: json['meetingUrl'] ?? '',
    );
  }
}

class CourseOfTheDayModel {
  final String courseId;
  final String title;
  final String subtitle;
  final String priceText;
  final String badgeText;
  final String imageUrl;

  CourseOfTheDayModel({
    required this.courseId,
    required this.title,
    required this.subtitle,
    required this.priceText,
    required this.badgeText,
    required this.imageUrl,
  });

  factory CourseOfTheDayModel.fromJson(Map<String, dynamic> json) {
    return CourseOfTheDayModel(
      courseId: json['courseId'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      priceText: json['priceText'] ?? '',
      badgeText: json['badgeText'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
