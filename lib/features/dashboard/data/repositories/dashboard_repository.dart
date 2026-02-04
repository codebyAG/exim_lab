import 'package:exim_lab/features/dashboard/data/data_sources/dashboard_remote_data_source.dart';
import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';

class DashboardRepository {
  final DashboardRemoteDataSource _dataSource = DashboardRemoteDataSource();

  Future<DashboardResponse> getDashboardData() async {
    return await _dataSource.getDashboardData();
  }
}
