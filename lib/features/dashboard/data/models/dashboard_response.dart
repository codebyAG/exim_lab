import 'package:exim_lab/features/courses/data/models/course_model.dart';
import 'package:exim_lab/features/freevideos/data/models/free_videos_model.dart';

class DashboardResponse {
  final AddonsData addons;
  final List<DashboardSection> sections;

  DashboardResponse({required this.addons, required this.sections});

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      addons: AddonsData.fromJson(json['addons'] ?? {}),
      sections:
          (json['sections'] as List?)
              ?.map((e) => DashboardSection.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DashboardSection {
  final String key;
  final String title;
  final String subtitle;
  final int order;
  final List<dynamic> data; // Can be List<CourseModel>, List<BannerModel>, etc.

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
  final String language;
  final bool darkMode;
  final String theme;
  final String font;
  final String fontSize;
  final String fontWeight;
  final String fontColor;
  final String backgroundColor;
  final String borderRadius;
  final String primaryColor;
  final String secondaryColor;
  final List<BannerModel> carousel;
  final BannerModel? popup;

  AddonsData({
    required this.language,
    required this.darkMode,
    required this.theme,
    required this.font,
    required this.fontSize,
    required this.fontWeight,
    required this.fontColor,
    required this.backgroundColor,
    required this.borderRadius,
    required this.primaryColor,
    required this.secondaryColor,
    required this.carousel,
    this.popup,
  });

  factory AddonsData.fromJson(Map<String, dynamic> json) {
    return AddonsData(
      language: json['language'] ?? '',
      darkMode: json['darkMode'] ?? false,
      theme: json['theme'] ?? 'light',
      font: json['font'] ?? '',
      fontSize: json['fontSize'] ?? '',
      fontWeight: json['fontWeight'] ?? '',
      fontColor: json['fontColor'] ?? '',
      backgroundColor: json['backgroundColor'] ?? '',
      borderRadius: json['borderRadius'] ?? '',
      primaryColor: json['primaryColor'] ?? '',
      secondaryColor: json['secondaryColor'] ?? '',
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
  final String type; // CAROUSEL or INLINE

  BannerModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ctaText,
    required this.ctaUrl,
    required this.isActive,
    required this.type,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      ctaText: json['ctaText'] ?? '',
      ctaUrl: json['ctaUrl'] ?? json['link'] ?? '',
      isActive: json['isActive'] ?? false,
      type: json['type'] ?? '',
    );
  }
}
