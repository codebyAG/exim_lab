import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';

import 'package:exim_lab/features/courses/data/models/course_model.dart';
import 'package:exim_lab/features/freevideos/data/models/free_videos_model.dart';

class DashboardRemoteDataSource {
  /// Fetch the skeleton (Popup + Section List)
  Future<DashboardResponse> getSections() async {
    return await callApi(
      ApiConstants.dashboardSections,
      parser: (json) => DashboardResponse.fromJson(json),
    );
  }

  /// Fetch all Banners (Carousel + Inline)
  Future<Map<String, List<BannerModel>>> getBanners() async {
    return await callApi(
      ApiConstants.dashboardBanners,
      parser: (json) {
        final carousel = (json['carousel'] as List?)
                ?.map((e) => BannerModel.fromJson(e))
                .toList() ??
            [];
        final inline = (json['inline'] as List?)
                ?.map((e) => BannerModel.fromJson(e))
                .toList() ??
            [];
        return {'carousel': carousel, 'inline': inline};
      },
    );
  }

  /// Fetch Popular Courses
  Future<List<CourseModel>> getPopularCourses() async {
    return await callApi(
      "${ApiConstants.dashboardPopular}?limit=10",
      parser: (json) => (json['data'] as List?)
              ?.map((e) => CourseModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  /// Fetch Recommended Courses
  Future<List<CourseModel>> getRecommendedCourses() async {
    return await callApi(
      "${ApiConstants.dashboardRecommended}?limit=10",
      parser: (json) => (json['data'] as List?)
              ?.map((e) => CourseModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  /// Fetch Continue Learning Courses
  Future<List<CourseModel>> getContinueCourses() async {
    return await callApi(
      "${ApiConstants.dashboardContinue}?limit=20",
      parser: (json) => (json['data'] as List?)
              ?.map((e) => CourseModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  /// Fetch Free Videos
  Future<List<FreeVideoModel>> getFreeVideos() async {
    return await callApi(
      "${ApiConstants.dashboardFreeVideos}?limit=10",
      parser: (json) => (json['data'] as List?)
              ?.map((e) => FreeVideoModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  /// Fetch Shorts
  Future<List<FreeVideoModel>> getShorts() async {
    return await callApi(
      "${ApiConstants.dashboardShorts}?limit=20",
      parser: (json) => (json['data'] as List?)
              ?.map((e) => FreeVideoModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  @Deprecated("Use split fetch methods instead")
  Future<DashboardResponse> getDashboardData() async {
    return await callApi(
      ApiConstants.dashboard,
      parser: (json) => DashboardResponse.fromJson(json),
      methodType: MethodType.get,
    );
  }
}
