import 'package:exim_lab/features/courses/data/data_sources/course_details_remote_data_sources.dart';
import 'package:flutter/material.dart';
import '../../data/models/course_details_model.dart';

class CourseDetailsState extends ChangeNotifier {
  final CourseDetailsRemoteDataSource _remoteDataSource;

  CourseDetailsState({CourseDetailsRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? CourseDetailsRemoteDataSource();

  bool isLoading = false;
  String? errorMessage;
  CourseDetailsModel? course;

  Future<void> fetchCourseDetails(String courseId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      course = await _remoteDataSource.getCourseDetails(courseId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
