import 'package:exim_lab/features/courses/data/data_sources/course_remote.dart';
import 'package:flutter/material.dart';
import '../../data/models/course_model.dart';

class CoursesState extends ChangeNotifier {
  final CoursesRemoteDataSource _remoteDataSource = CoursesRemoteDataSource();

  /// 📦 DATA
  List<CourseModel> courses = [];

  /// ⏳ STATE
  bool isLoading = false;
  String? errorMessage;

  /// 🔁 FETCH COURSES
  Future<void> fetchCourses({int page = 1, int limit = 20}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      courses = await _remoteDataSource.getCourses(page: page, limit: limit);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
