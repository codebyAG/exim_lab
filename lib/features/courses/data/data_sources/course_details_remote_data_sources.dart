import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import '../models/course_details_model.dart';

class CourseDetailsRemoteDataSource {
  Future<CourseDetailsModel> getCourseDetails(String courseId) {
    return callApi<CourseDetailsModel>(
      '${ApiConstants.baseUrl}${ApiConstants.courses}/$courseId',
      methodType: MethodType.get,
      parser: (json) {
        return CourseDetailsModel.fromJson(json);
      },
    );
  }
}
