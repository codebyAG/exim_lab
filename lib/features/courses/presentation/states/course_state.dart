import 'package:exim_lab/features/courses/data/data_sources/course_remote.dart';
import 'package:flutter/material.dart';
import '../../data/models/course_model.dart';

class CoursesState extends ChangeNotifier {
  final CoursesRemoteDataSource _remoteDataSource = CoursesRemoteDataSource();

  /// 📦 DATA
  List<CourseModel> courses = [];
  List<CourseModel> myCourses = [];

  /// ⏳ STATE
  bool isLoading = false;
  bool isMyCoursesLoading = false;
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
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMyCourses() async {
    isMyCoursesLoading = true;
    notifyListeners();
    try {
      myCourses = await _remoteDataSource.getMyCourses();
    } catch (e) {
      // Handle error cleanly, maybe show toast or just empty list
      debugPrint("Error fetching my courses: $e");
    }
    isMyCoursesLoading = false;
    notifyListeners();
  }
}
