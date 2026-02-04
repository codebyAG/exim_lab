import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';
import 'package:exim_lab/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardRepository _repository = DashboardRepository();

  DashboardResponse? data;
  bool isLoading = false;
  String? error;

  Future<void> fetchDashboardData() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      data = await _repository.getDashboardData();
    } catch (e) {
      error = e.toString();
      debugPrint("DashboardProvider Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
