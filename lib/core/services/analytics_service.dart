import 'package:exim_lab/core/constants/analytics_constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService {
  FirebaseAnalytics get _analytics => FirebaseAnalytics.instance;

  static String? _userMobile;

  void setUserMobile(String? mobile) {
    _userMobile = mobile;
    debugPrint('📊 Analytics Mobile Set: $mobile');
  }

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // 🔹 GENERIC LOGGING
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    try {
      final Map<String, Object> finalParams = parameters != null
          ? Map.from(parameters)
          : {};

      if (_userMobile != null) {
        finalParams[AnalyticsConstants.phoneNumber] = _userMobile!;
      }

      await _analytics.logEvent(name: name, parameters: finalParams);
      debugPrint('📊 Analytics Event: $name, Params: $finalParams');
    } catch (e) {
      debugPrint('⚠️ Analytics Error: $e');
    }
  }

  // 🔹 SCREEN TRACKING (Manual if needed, auto is handled by Observer)
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  // 🔹 FIRST APP OPEN
  Future<void> checkFirstAppOpen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isFirstRun = prefs.getBool('is_first_run') ?? true;

      if (isFirstRun) {
        await logEvent(AnalyticsConstants.appFirstOpen);
        await prefs.setBool('is_first_run', false);
        debugPrint('🚀 First App Open Logged');
      }
    } catch (e) {
      debugPrint('⚠️ Error checking first run: $e');
    }
  }

  // 🔹 USER IDENTIFICATION
  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  // 🔹 AUTH AUTHENTICATION
  Future<void> logLogin({required String method}) async {
    await _analytics.logLogin(loginMethod: method);
    await logEvent(
      AnalyticsConstants.login,
      parameters: {AnalyticsConstants.method: method},
    );
  }

  Future<void> logSignUp({required String method}) async {
    await _analytics.logSignUp(signUpMethod: method);
    await logEvent(
      AnalyticsConstants.signUp,
      parameters: {AnalyticsConstants.method: method},
    );
  }

  Future<void> logLogout() async {
    await logEvent(AnalyticsConstants.logout);
  }

  // 🔹 CONTENT EVENTS
  Future<void> logCourseView({
    required String courseId,
    required String courseName,
  }) async {
    await _analytics.logViewItem(
      currency: 'INR',
      value: 0,
      items: [
        AnalyticsEventItem(
          itemId: courseId,
          itemName: courseName,
          itemCategory: 'Course',
        ),
      ],
    );
    await logEvent(
      AnalyticsConstants.viewCourseDetails,
      parameters: {
        AnalyticsConstants.courseId: courseId,
        'course_name': courseName,
      },
    );
  }

  Future<void> logLessonStart({
    required String lessonId,
    required String lessonName,
    required String courseName,
  }) async {
    await logEvent(
      AnalyticsConstants.lessonStart,
      parameters: {
        AnalyticsConstants.lessonId: lessonId,
        AnalyticsConstants.lessonName: lessonName,
        'course_name': courseName,
      },
    );
  }

  Future<void> logVideoStart({
    required String videoId,
    required String videoTitle,
  }) async {
    await logEvent(
      AnalyticsConstants.videoStart,
      parameters: {
        AnalyticsConstants.videoId: videoId,
        AnalyticsConstants.videoTitle: videoTitle,
      },
    );
  }

  Future<void> logVideoComplete({
    required String videoId,
    required String videoTitle,
  }) async {
    await logEvent(
      AnalyticsConstants.videoComplete,
      parameters: {
        AnalyticsConstants.videoId: videoId,
        AnalyticsConstants.videoTitle: videoTitle,
      },
    );
  }

  // 🔹 INTERACTIONS
  Future<void> logButtonTap({
    required String buttonName,
    required String screenName,
  }) async {
    await logEvent(
      AnalyticsConstants.buttonTap,
      parameters: {
        AnalyticsConstants.buttonName: buttonName,
        AnalyticsConstants.screenName: screenName,
      },
    );
  }

  Future<void> logBannerClick({
    required String ctaUrl,
    required String imageUrl,
  }) async {
    await logEvent(
      AnalyticsConstants.bannerClick,
      parameters: {
        AnalyticsConstants.ctaUrl: ctaUrl,
        AnalyticsConstants.imageUrl: imageUrl,
      },
    );
  }

  Future<void> logSearch({required String searchTerm}) async {
    await _analytics.logSearch(searchTerm: searchTerm);
    await logEvent(
      AnalyticsConstants.search,
      parameters: {AnalyticsConstants.searchTerm: searchTerm},
    );
  }

  Future<void> logShare({
    required String contentId,
    required String contentType,
    required String method,
  }) async {
    await _analytics.logShare(
      contentType: contentType,
      itemId: contentId,
      method: method,
    );
    await logEvent(
      AnalyticsConstants.shareContent,
      parameters: {
        AnalyticsConstants.contentId: contentId,
        AnalyticsConstants.contentType: contentType,
        AnalyticsConstants.method: method,
      },
    );
  }

  Future<void> logError({required String message}) async {
    await logEvent(
      AnalyticsConstants.error,
      parameters: {AnalyticsConstants.errorMessage: message},
    );
  }

  Future<void> logCourseComplete({
    required String courseId,
    required String courseName,
  }) async {
    await logEvent(
      AnalyticsConstants.courseComplete,
      parameters: {
        AnalyticsConstants.courseId: courseId,
        'course_name': courseName,
      },
    );
  }
}
