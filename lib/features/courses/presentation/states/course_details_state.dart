import 'dart:convert';
import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/features/courses/data/models/course_details_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CourseDetailsState extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  CourseDetailsModel? course;

  Future<void> fetchCourseDetails(String courseId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await http.get(
        Uri.parse('${ApiConstants.courses}/$courseId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        course = CourseDetailsModel.fromJson(data);
      } else {
        errorMessage = 'Failed to load course details';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
