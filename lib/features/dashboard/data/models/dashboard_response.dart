import 'package:exim_lab/features/courses/data/models/course_model.dart';
import 'package:exim_lab/features/freevideos/data/models/free_videos_model.dart';

class DashboardResponse {
  final AddonsData addons;
  final List<DashboardSection> sections;
  final LiveSeminarModel?
  liveSeminar; // Optional, might come separately or not at all
  final CourseOfTheDayModel? courseOfTheDay; // optional

  DashboardResponse({
    required this.addons,
    required this.sections,
    this.liveSeminar,
    this.courseOfTheDay,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      addons: AddonsData.fromJson(json['addons'] ?? {}),
      sections:
          (json['sections'] as List?)
              ?.map((e) => DashboardSection.fromJson(e))
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

class DashboardSection {
  final String key;
  final String title;
  final String subtitle;
  final int order;
  final List<dynamic>
  data; // Can be List<CourseModel> or List<BannerModel> etc.

  DashboardSection({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.order,
    required this.data,
  });

  factory DashboardSection.fromJson(Map<String, dynamic> json) {
    String key = (json['key'] ?? '').toString().trim();
    List rawData = (json['data'] as List?) ?? [];
    List parsedData = [];

    if (key == 'course' ||
        key.contains('Popular') ||
        key.contains('Recommended') ||
        key == 'continue') {
      parsedData = rawData.map((e) => CourseModel.fromJson(e)).toList();
    } else if (key == 'freeVideos') {
      parsedData = rawData.map((e) => FreeVideoModel.fromJson(e)).toList();
    } else if (key == 'banner') {
      parsedData = rawData.map((e) => BannerModel.fromJson(e)).toList();
    }

    return DashboardSection(
      key: key,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      order: json['order'] ?? 0,
      data: parsedData,
    );
  }
}

class AddonsData {
  final List<BannerModel> carousel;
  final BannerModel? popup;

  AddonsData({required this.carousel, this.popup});

  factory AddonsData.fromJson(Map<String, dynamic> json) {
    return AddonsData(
      carousel:
          (json['carousel'] as List?)
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
      ctaUrl: json['ctaUrl'] ?? json['link'] ?? '',
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
