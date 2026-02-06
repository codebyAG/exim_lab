import 'dart:developer' as dev;
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> setupFirebase() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      dev.log('User granted permission');
    } else {
      dev.log('User declined or has not accepted permission');
    }
  }

  Future<void> subsScribetoAlltopic() async {
    dev.log("Subscribing to topic: live");
    try {
      await _firebaseMessaging.subscribeToTopic("live");
    } catch (e) {
      dev.log("Error subscribing to topic: $e");
    }
  }

  Future<String?> getFirebaseToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      dev.log("FCM Token: $token");
      return token;
    } catch (e) {
      dev.log("Error getting FCM token: $e");
    }
    return null;
  }

  // 🔹 Background Message Handler
  static Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
    dev.log("Handling a background message: ${message.messageId}");

    String title = message.notification?.title ?? message.data["title"] ?? "";
    String body = message.notification?.body ?? message.data["body"] ?? "";
    String? image = message.data["image"];

    if (title.isNotEmpty) {
      if (image != null && image.isNotEmpty) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: Random().nextInt(10000),
            channelKey: 'basic',
            title: title,
            body: body,
            bigPicture: image,
            notificationLayout: NotificationLayout.BigPicture,
            fullScreenIntent: true,
            wakeUpScreen: true,
          ),
        );
      } else {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: Random().nextInt(10000),
            channelKey: 'basic',
            title: title,
            body: body,
            fullScreenIntent: true,
            wakeUpScreen: true,
          ),
        );
      }
    }
  }
}
