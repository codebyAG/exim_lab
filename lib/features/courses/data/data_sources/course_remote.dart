import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import '../models/course_model.dart';

class CoursesRemoteDataSource {
  Future<List<CourseModel>> getCourses({int page = 1, int limit = 20}) async {
    return callApi<List<CourseModel>>(
      '${ApiConstants.baseUrl}${ApiConstants.courses}',
      methodType: MethodType.get,
      queryParameters: {'page': page, 'limit': limit},
      parser: (json) {
        final List list = json['data'];
        return list.map((e) => CourseModel.fromJson(e)).toList();
      },
    );
  }
}
