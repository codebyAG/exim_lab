import 'dart:developer' as developer;
import 'package:exim_lab/features/courses/data/models/course_model.dart';
import 'package:exim_lab/features/dashboard/data/models/dashboard_response.dart';
import 'package:exim_lab/features/dashboard/data/models/founder_model.dart';
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
  FounderModel? founderInfo;
  bool isLoading = false;
  String? error;

  bool _isTourSeen = false;
  bool _isInterestDialogShown = false;

  bool get isTourSeen => _isTourSeen;
  bool get isInterestDialogShown => _isInterestDialogShown;

  // --- Processed Data Getters ---

  /// Courses the user is currently taking
  List<CourseModel> get continueCourses {
    if (data == null) return [];
    final section = data!.sections
        .where((s) => s.key == 'continue')
        .firstOrNull;
    return section?.data.whereType<CourseModel>().toList() ?? [];
  }

  /// Helper to get a section by key or generic type
  DashboardSection? getSection(String key) {
    if (data == null) return null;

    final target = key.toLowerCase();
    return data!.sections.where((s) {
      final sectionKey = s.key.toLowerCase();
      final sectionType = s.sectionType?.toLowerCase() ?? '';

      // Match on key OR sectionType
      bool matches = sectionKey == target || sectionType == target;

      // 🛡️ BLOCKER: If we are looking for a COURSE section (popular/recommended),
      // we must EXCLUDE any section that is actually a Video or Short by its KEY.
      if (matches &&
          (target == 'popular' ||
              target == 'recommended' ||
              target == 'course')) {
        if (sectionKey.contains('video') || sectionKey.contains('short')) {
          return false; // Skip because it's actually a video section
        }
      }

      return matches;
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
      allBanners.addAll(section.data.whereType<BannerModel>());
    }
    return allBanners;
  }

  // --- Onboarding Logic ---

  Future<void> initOnboardingState() async {
    final prefs = await SharedPreferences.getInstance();
    _isTourSeen = prefs.getBool('dashboard_v4_tour_seen') ?? false;
    _isInterestDialogShown = prefs.getBool('interest_dialog_shown') ?? false;

    developer.log(
      '📦 Onboarding State Initialized:\n'
      '   - dashboard_v3_tour_seen: $_isTourSeen\n'
      '   - interest_dialog_shown: $_isInterestDialogShown',
      name: 'ONBOARDING',
    );

    notifyListeners();
  }

  Future<void> markTourAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dashboard_v4_tour_seen', true);
    _isTourSeen = true;

    developer.log(
      '💾 Persisting State: dashboard_v4_tour_seen -> true',
      name: 'ONBOARDING',
    );

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

    if (moduleProvider.isEnabled('community')) {
      items.add(
        DashboardNavItem(
          labelKey: 'community',
          icon: Icons.chat_bubble_outline_rounded,
          activeIcon: Icons.chat_bubble_rounded,
          identifier: 'community',
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
      // 1. Fetch Skeleton (Sections + Popup)
      final skeleton = await _repository.getSections();
      data = skeleton;
      notifyListeners();

      // 2. Fetch Founder, Banners and content sections in parallel
      await Future.wait([
        _fetchFounderInfo(),
        _fetchBanners(),
        _fetchAndStitch('popular', _repository.getPopularCourses()),
        _fetchAndStitch('recommended', _repository.getRecommendedCourses()),
        _fetchAndStitch('continue', _repository.getContinueCourses()),
        _fetchAndStitch('freeVideos', _repository.getFreeVideos()),
        _fetchAndStitch('shorts', _repository.getShorts()),
      ]);

      developer.log("✅ Dashboard Split Fetch Complete", name: "API_SPLIT");
    } catch (e) {
      error = e.toString();
      developer.log("❌ Dashboard Split Fetch Error: $e", name: "API_SPLIT");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Helper to fetch content for a specific section and update the data state
  Future<void> _fetchAndStitch(
    String key,
    Future<List<dynamic>> fetchCall,
  ) async {
    try {
      final results = await fetchCall;
      if (data == null) return;

      final updatedSections = data!.sections.map((section) {
        final sectionKey = section.key.toLowerCase();
        final sectionType = section.sectionType?.toLowerCase() ?? '';
        final targetKey = key.toLowerCase();

        // Match on key OR sectionType
        if (sectionKey == targetKey || sectionType == targetKey) {
          // 🛡️ CRITICAL SAFETY:
          // If this section is explicitly a Video section (by key),
          // block any Course data (like 'recommended' or 'popular') from entering it.
          if (sectionKey.contains('video') || sectionKey.contains('short')) {
            if (!targetKey.contains('video') && !targetKey.contains('short')) {
              return section; // Block Course data from the Video section
            }
          }

          final count = results.length;
          developer.log(
            "✅ Stitched [$targetKey] with $count items into section [$sectionKey]",
            name: "API_SPLIT",
          );
          return section.copyWith(data: results);
        }
        return section;
      }).toList();

      data = data!.copyWith(sections: updatedSections);
      notifyListeners();
    } catch (e) {
      developer.log("⚠️ Failed to load section '$key': $e", name: "API_SPLIT");
    }
  }

  /// Specialized fetch for Banners (updates carousel in addons + inline sections)
  Future<void> _fetchBanners() async {
    try {
      final bannerMap = await _repository.getBanners();
      if (data == null) return;

      final carousel = bannerMap['carousel'] ?? [];
      final inline = bannerMap['inline'] ?? [];

      // Update Carousel in Addons
      final updatedAddons = data!.addons.copyWith(carousel: carousel);

      // Update Inline Banner Sections
      final updatedSections = data!.sections.map((section) {
        if (section.key.toLowerCase() == 'banner') {
          return section.copyWith(data: inline);
        }
        return section;
      }).toList();

      data = data!.copyWith(addons: updatedAddons, sections: updatedSections);
      notifyListeners();
    } catch (e) {
      developer.log("⚠️ Failed to load banners: $e", name: "API_SPLIT");
    }
  }

  /// Fetch Founder Info
  Future<void> _fetchFounderInfo() async {
    try {
      founderInfo = await _repository.getFounderInfo();
      notifyListeners();
    } catch (e) {
      developer.log("⚠️ Failed to load founder info: $e", name: "API_SPLIT");
    }
  }
}
