import 'package:exim_lab/core/constants/api_constants.dart';
import 'package:exim_lab/core/functions/api_call.dart';
import 'package:exim_lab/core/constants/analytics_constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_analytics_observer.dart';

class AnalyticsService {
  FirebaseAnalytics get _analytics => FirebaseAnalytics.instance;

  static String? _userMobile;

  void setUserMobile(String? mobile) {
    _userMobile = mobile;
    debugPrint('📊 Analytics Mobile Set: $mobile');
  }

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  CustomAnalyticsObserver getCustomObserver() =>
      CustomAnalyticsObserver(analyticsService: this);

  // 🔹 GENERIC LOGGING
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    try {
      final Map<String, Object> finalParams = parameters != null
          ? Map.from(parameters)
          : {};

      if (_userMobile != null) {
        finalParams[AnalyticsConstants.phoneNumber] = _userMobile!;
      }

      // 1. Log to Firebase (Keep as secondary/primary until transition complete)
      await _analytics.logEvent(name: name, parameters: finalParams);
      debugPrint('📊 Firebase Event: $name, Params: $finalParams');

      // 2. Log to Custom Server
      await _logToServer(name, finalParams);
    } catch (e) {
      debugPrint('⚠️ Analytics Error: $e');
    }
  }

  Future<void> _logToServer(
    String eventName,
    Map<String, Object> params,
  ) async {
    try {
      // 🔸 Check for Token (Only log to strict Backend API if logged in)
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(
        'auth_token',
      ); // Ensure this matches login key

      if (token == null || token.isEmpty) {
        // debugPrint('ℹ️ Skipping Server Log (No Auth Token): $eventName');
        return;
      }

      await callApi(
        ApiConstants.logAnalytics,
        methodType: MethodType.post,
        requestData: {
          'event_name': eventName,
          'parameters': params,
          'phone_number': _userMobile ?? '',
          'timestamp': DateTime.now().toIso8601String(),
        },
        parser: (json) => json,
      );
      debugPrint('🚀 Server Analytics Logged: $eventName');
    } catch (e) {
      // debugPrint('⚠️ Server Analytics Error: $e'); // Silent fail to avoid spam
    }
  }

  // 🔹 PUBLIC INSTALL TRACKING (No Token)
  Future<void> logInstallSource(Map<String, dynamic> params) async {
    try {
      await callApi(
        ApiConstants.logInstall,
        methodType: MethodType.post,
        requestData: {
          'parameters': params,
          'timestamp': DateTime.now().toIso8601String(),
          // No phone number because this matches anonymous install
        },
        parser: (json) => json,
      );
      debugPrint('🚀 Install Source Logged to Public API');
    } catch (e) {
      debugPrint('⚠️ Error logging install source: $e');
    }
  }

  // 🔹 SCREEN TRACKING (Manual if needed, auto is handled by Observer)
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
    await logEvent(
      AnalyticsConstants.screenName,
      parameters: {AnalyticsConstants.screenName: screenName},
    );
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

  // 🔹 QUIZ
  Future<void> logQuizTopicView(String category) async {
    await logEvent(
      AnalyticsConstants.quizTopicView,
      parameters: {'category': category},
    );
  }

  Future<void> logQuizStart({
    required String quizId,
    required String title,
  }) async {
    await logEvent(
      AnalyticsConstants.quizStart,
      parameters: {AnalyticsConstants.quizId: quizId, 'quiz_title': title},
    );
  }

  Future<void> logQuizFinish({required String quizId}) async {
    await logEvent(
      AnalyticsConstants.quizFinish,
      parameters: {AnalyticsConstants.quizId: quizId},
    );
  }

  // 🔹 NEWS
  Future<void> logNewsView({
    required String newsId,
    required String title,
  }) async {
    await logEvent(
      AnalyticsConstants.newsView,
      parameters: {'news_id': newsId, 'news_title': title},
    );
  }

  // 🔹 SHORTS
  Future<void> logShortsView({
    required String shortId,
    required String title,
  }) async {
    await logEvent(
      AnalyticsConstants.shortsView,
      parameters: {
        AnalyticsConstants.shortId: shortId,
        AnalyticsConstants.title: title,
      },
    );
  }

  // 🔹 AI CHAT
  Future<void> logAiChatView() async {
    await logEvent(AnalyticsConstants.aiChatView);
  }

  Future<void> logAiChatMessageSent() async {
    await logEvent('ai_message_sent');
  }

  // 🔹 TOOLS
  Future<void> logToolUse({required String toolName, String? action}) async {
    await logEvent(
      AnalyticsConstants.toolUse,
      parameters: {
        AnalyticsConstants.toolName: toolName,
        if (action != null) 'action': action,
      },
    );
  }

  // 🔹 PROFILE
  Future<void> logProfileView() async {
    await logEvent(AnalyticsConstants.profileView);
  }
}
