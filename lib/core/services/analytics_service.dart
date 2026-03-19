import 'dart:convert';
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
  static bool _isSyncing = false; // Prevent overlapping syncs

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

      // 2. Queue for Custom Server (Batching)
      await _queueEventForServer(name, finalParams);
    } catch (e) {
      debugPrint('⚠️ Analytics Error: $e');
    }
  }

  // 🔹 BATCHING LOGIC
  static const String _queueKey = 'analytics_events_queue';
  static const String _lastSyncKey = 'analytics_last_sync_time';
  static const int _syncIntervalHours = 12;

  Future<void> _queueEventForServer(
    String eventName,
    Map<String, Object> params,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      // Only queue if user is authenticated (as per current backend rules)
      if (token == null || token.isEmpty) return;

      // 1. Prepare event object
      final eventData = {
        'event_name': eventName,
        'parameters': params,
        'event_timestamp': DateTime.now().toUtc().toIso8601String(),
      };

      // 2. Add to Local List (JSON String List)
      final List<String> currentQueue = prefs.getStringList(_queueKey) ?? [];
      currentQueue.add(jsonEncode(eventData));
      await prefs.setStringList(_queueKey, currentQueue);

      debugPrint(
        '📥 Event Queued Locally: $eventName (Total: ${currentQueue.length})',
      );

      // 3. Check if it's time to sync
      await _checkAndSyncEvents(prefs);
    } catch (e) {
      debugPrint('⚠️ Error queueing event: $e');
    }
  }

  Future<void> _checkAndSyncEvents(SharedPreferences prefs) async {
    if (_isSyncing) return;

    final lastSyncStr = prefs.getString(_lastSyncKey);
    final now = DateTime.now();

    if (lastSyncStr == null) {
      // First run: Initialize the 12-hour countdown
      await prefs.setString(_lastSyncKey, now.toIso8601String());
      debugPrint('🕒 Analytics clock started. First sync in 12 hours.');
      return;
    }

    final lastSync = DateTime.parse(lastSyncStr);
    final difference = now.difference(lastSync).inHours;

    if (difference >= _syncIntervalHours) {
      debugPrint('🕒 12 Hours passed. Triggering Analytics Sync...');
      await _syncEventsToServer(prefs);
    }
  }

  Future<void> _syncEventsToServer(SharedPreferences prefs) async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final List<String> queue = prefs.getStringList(_queueKey) ?? [];
      if (queue.isEmpty) {
        await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
        return;
      }

      // 1. Convert List<String> (JSON) to List<Map>
      final List<Map<String, dynamic>> batchedData = queue
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList();

      // 2. Send as Array to Backend
      await callApi(
        ApiConstants.logAnalytics,
        methodType: MethodType.post,
        requestData: {'events': batchedData},
        parser: (json) => json,
        logErrorEvent: false, // Prevent infinite recursion if sync fails
      );

      // 3. Clear Queue on Success
      await prefs.remove(_queueKey);
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
      debugPrint(
        '🚀 Successfully Batched ${batchedData.length} Events to Server',
      );
    } catch (e) {
      debugPrint('⚠️ Batch Sync Failed: $e');
      // Update last sync time anyway to prevent retrying on every event
      // This enforces the 12-hour rule even for retries
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
    } finally {
      _isSyncing = false;
    }
  }

  // 🗑️ REMOVED THE OLD REAL-TIME METHOD

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
        logErrorEvent: false, // Prevent recursion for public tracking
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
