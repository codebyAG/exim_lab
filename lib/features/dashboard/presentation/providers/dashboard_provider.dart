import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';
import 'package:exim_lab/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DashboardOnboardingAction { none, startTour, showInterestDialog, showPromoBanner }

class DashboardProvider extends ChangeNotifier {
  final DashboardRepository _repository = DashboardRepository();

  DashboardResponse? data;
  bool isLoading = false;
  String? error;

  bool _isTourSeen = true;
  bool _isInterestDialogShown = true;

  bool get isTourSeen => _isTourSeen;
  bool get isInterestDialogShown => _isInterestDialogShown;

  Future<void> initOnboardingState() async {
    final prefs = await SharedPreferences.getInstance();
    _isTourSeen = prefs.getBool('dashboard_v3_tour_seen') ?? false;
    _isInterestDialogShown = prefs.getBool('interest_dialog_shown') ?? false;
    notifyListeners();
  }

  Future<void> markTourAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dashboard_v3_tour_seen', true);
    _isTourSeen = true;
    notifyListeners();
  }

  Future<void> markInterestDialogAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('interest_dialog_shown', true);
    _isInterestDialogShown = true;
    notifyListeners();
  }

  /// Determines the next logical display action after data has loaded.
  DashboardOnboardingAction getNextOnboardingAction({
    required bool hasNoInterests,
  }) {
    if (!_isTourSeen) {
      return DashboardOnboardingAction.startTour;
    }

    if (hasNoInterests && !_isInterestDialogShown) {
      return DashboardOnboardingAction.showInterestDialog;
    }

    if (data?.addons.popup != null) {
      return DashboardOnboardingAction.showPromoBanner;
    }

    return DashboardOnboardingAction.none;
  }

  Future<void> fetchDashboardData() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      data = await _repository.getDashboardData();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
