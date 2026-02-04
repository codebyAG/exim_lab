import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';

class DashboardRemoteDataSource {
  Future<DashboardResponse> getDashboardData() async {
    return await callApi(
      ApiConstants.dashboard,
      parser: (json) => DashboardResponse.fromJson(json),
      methodType: MethodType.get,
    );
  }
}
