import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:exim_lab/core/constants/api_constants.dart';
import '../models/course_model.dart';

class CoursesRemoteDataSource {
  Future<List<CourseModel>> getCourses({
    int page = 1,
    int limit = 20,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.courses}?page=$page&limit=$limit',
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List list = decoded['data'];

      return list.map((e) => CourseModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }
}
