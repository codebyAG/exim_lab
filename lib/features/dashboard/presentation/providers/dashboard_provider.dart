import 'package:exim_lab/features/courses/data/models/course_model.dart';
import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';
import 'package:exim_lab/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DashboardOnboardingAction {
  none,
  startTour,
  showInterestDialog,
  showPromoBanner,
}

class DashboardNavItem {
  final String labelKey;
  final IconData icon;
  final IconData activeIcon;
  final String identifier; // home, shorts, courses, news, profile

  DashboardNavItem({
    required this.labelKey,
    required this.icon,
    required this.activeIcon,
    required this.identifier,
  });
}

class DashboardProvider extends ChangeNotifier {
  final DashboardRepository _repository = DashboardRepository();

  DashboardResponse? data;
  bool isLoading = false;
  String? error;

  bool _isTourSeen = true;
  bool _isInterestDialogShown = true;

  bool get isTourSeen => _isTourSeen;
  bool get isInterestDialogShown => _isInterestDialogShown;

  // --- Processed Data Getters ---

  /// Courses the user is currently taking
  List<CourseModel> get continueCourses {
    final section = data?.sections
        .where((s) => s.key == 'continue')
        .firstOrNull;
    return section?.data.cast<CourseModel>() ?? [];
  }

  /// Helper to get a section by key or generic type
  DashboardSection? getSection(String key) {
    return data?.sections.where((s) {
      final normalized = s.key.toLowerCase();
      return normalized == key.toLowerCase() ||
          normalized.contains(key.toLowerCase());
    }).firstOrNull;
  }

  /// 📈 Popular Courses
  DashboardSection? get popularCourseSection => getSection('popular');

  /// ⭐ Recommended Courses
  DashboardSection? get recommendedCourseSection => getSection('recommended');

  /// 🎓 All / Standard Courses
  DashboardSection? get allCourseSection => getSection('course');

  /// The 'Free Videos' section
  DashboardSection? get freeVideoSection => getSection('freeVideos');

  /// All inline banners
  List<BannerModel> get inlineBanners {
    final bannerSections = data?.sections.where((s) => s.key == 'banner') ?? [];
    List<BannerModel> allBanners = [];
    for (var section in bannerSections) {
      allBanners.addAll(section.data.cast<BannerModel>());
    }
    return allBanners;
  }

  // --- Onboarding Logic ---

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

  // --- Navigation Schema ---

  List<DashboardNavItem> getNavigationSchema(dynamic moduleProvider) {
    List<DashboardNavItem> items = [
      DashboardNavItem(
        labelKey: 'home',
        icon: Icons.home_rounded,
        activeIcon: Icons.home_filled,
        identifier: 'home',
      ),
    ];

    if (moduleProvider.isEnabled('shortVideos')) {
      items.add(
        DashboardNavItem(
          labelKey: 'shorts',
          icon: Icons.slow_motion_video_rounded,
          activeIcon: Icons.slow_motion_video,
          identifier: 'shorts',
        ),
      );
    }

    if (moduleProvider.isEnabled('courses')) {
      items.add(
        DashboardNavItem(
          labelKey: 'courses',
          icon: Icons.play_circle_outline_rounded,
          activeIcon: Icons.play_circle_filled_rounded,
          identifier: 'courses',
        ),
      );
    }

    if (moduleProvider.isEnabled('news')) {
      items.add(
        DashboardNavItem(
          labelKey: 'news',
          icon: Icons.newspaper_rounded,
          activeIcon: Icons.newspaper,
          identifier: 'news',
        ),
      );
    }

    items.add(
      DashboardNavItem(
        labelKey: 'profile',
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        identifier: 'profile',
      ),
    );

    return items;
  }

  // --- Data Fetching ---

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
