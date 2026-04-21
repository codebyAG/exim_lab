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

  /// Creates a copy of DashboardResponse with certain parts updated.
  DashboardResponse copyWith({
    AddonsData? addons,
    List<DashboardSection>? sections,
  }) {
    return DashboardResponse(
      addons: addons ?? this.addons,
      sections: sections ?? this.sections,
    );
  }
}

class DashboardSection {
  final String key;
  final String title;
  final String subtitle;
  final int order;
  final bool isActive;
  final String? sectionType;
  final List<dynamic> data; // Can be List<CourseModel>, List<BannerModel>, etc.

  DashboardSection({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.order,
    this.isActive = true,
    this.sectionType,
    required this.data,
  });

  factory DashboardSection.fromJson(Map<String, dynamic> json) {
    String key = (json['key'] ?? '').toString().trim();
    List rawData = (json['data'] as List?) ?? [];
    List parsedData = [];

    final normalizedKey = key.toLowerCase();
    final type = (json['sectionType'] ?? '').toString().toLowerCase();

    // Mapping based on Key OR SectionType
    // 🛡️ High Priority: Always check for Video/Shorts first to prevent key hijacking
    if (normalizedKey == 'freevideos' ||
        normalizedKey == 'shorts' ||
        type == 'shorts' ||
        type == 'freevideos') {
      parsedData = rawData.map((e) => FreeVideoModel.fromJson(e)).toList();
    } else if (normalizedKey == 'course' ||
        normalizedKey == 'continue' ||
        type == 'popular' ||
        type == 'recommended') {
      parsedData = rawData.map((e) => CourseModel.fromJson(e)).toList();
    } else if (normalizedKey == 'banner') {
      parsedData = rawData.map((e) => BannerModel.fromJson(e)).toList();
    }

    return DashboardSection(
      key: key,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      order: json['order'] ?? 0,
      isActive: json['isActive'] ?? true,
      sectionType: json['sectionType'],
      data: parsedData,
    );
  }

  DashboardSection copyWith({
    List<dynamic>? data,
    String? title,
    String? subtitle,
  }) {
    return DashboardSection(
      key: key,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      order: order,
      isActive: isActive,
      sectionType: sectionType,
      data: data ?? this.data,
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

  AddonsData copyWith({
    List<BannerModel>? carousel,
    BannerModel? popup,
  }) {
    return AddonsData(
      language: language,
      darkMode: darkMode,
      theme: theme,
      font: font,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontColor: fontColor,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      carousel: carousel ?? this.carousel,
      popup: popup ?? this.popup,
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
      ctaUrl: json['ctaUrl'] ?? json['linkUrl'] ?? json['link'] ?? '',
      isActive: json['isActive'] ?? false,
      type: json['type'] ?? '',
    );
  }
}
