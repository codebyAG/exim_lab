import 'package:exim_lab/features/dashboard/data/data_sources/dashboard_remote_data_source.dart';
import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';
import 'package:exim_lab/features/courses/data/models/course_model.dart';
import 'package:exim_lab/features/dashboard/data/models/founder_model.dart';
import 'package:exim_lab/features/freevideos/data/models/free_videos_model.dart';

class DashboardRepository {
  final DashboardRemoteDataSource _dataSource = DashboardRemoteDataSource();

  Future<FounderModel> getFounderInfo() => _dataSource.getFounderData();

  Future<DashboardResponse> getSections() => _dataSource.getSections();

  Future<Map<String, List<BannerModel>>> getBanners() =>
      _dataSource.getBanners();

  Future<List<CourseModel>> getPopularCourses() =>
      _dataSource.getPopularCourses();

  Future<List<CourseModel>> getRecommendedCourses() =>
      _dataSource.getRecommendedCourses();

  Future<List<CourseModel>> getContinueCourses() =>
      _dataSource.getContinueCourses();

  Future<List<FreeVideoModel>> getFreeVideos() => _dataSource.getFreeVideos();

  Future<List<FreeVideoModel>> getShorts() => _dataSource.getShorts();

  @Deprecated("Use split fetch methods instead")
  Future<DashboardResponse> getDashboardData() async {
    return await _dataSource.getDashboardData();
  }
}
