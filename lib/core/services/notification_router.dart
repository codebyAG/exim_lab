import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:exim_lab/features/news/presentation/screens/news_details_screen.dart';

/// Routes notification taps (FCM / local / in-app list) to the right screen.
///
/// Expected payload keys from backend:
///   `{ "type": "news", "newsId": "..." }`
/// In-app notifications may instead carry linkUrl: `news://id`.
class NotificationRouter {
  NotificationRouter._();

  /// Global key wired into [MaterialApp] so we can navigate without context.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Route based on a data payload (FCM `message.data` or awesome payload).
  static void routeFromData(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return;

    final type = data['type']?.toString();
    if (type == 'news') {
      final id = data['newsId']?.toString();
      if (id != null && id.isNotEmpty) {
        openNewsDetails(id);
      }
    }
  }

  /// Extract a news id from an in-app notification linkUrl (`news://id`).
  static String? newsIdFromLink(String? linkUrl) {
    if (linkUrl == null) return null;
    if (linkUrl.startsWith('news://')) {
      final id = linkUrl.substring('news://'.length).trim();
      return id.isEmpty ? null : id;
    }
    return null;
  }

  static void openNewsDetails(String newsId) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => NewsDetailScreen(newsId: newsId),
      ),
    );
  }

  /// AwesomeNotifications tap listener (local notifications shown by
  /// FirebaseMessagingService carry the FCM data as payload).
  @pragma('vm:entry-point')
  static Future<void> onActionReceived(ReceivedAction action) async {
    routeFromData(action.payload);
  }
}
