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
  }

  Future<void> subsScribetoAlltopic() async {
    try {
      await _firebaseMessaging.subscribeToTopic("live");
    } catch (e) {
      // ignore
    }
  }

  Future<String?> getFirebaseToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      return null;
    }
  }

  Future<void> initPushNotifications() async {
    await _firebaseMessaging.getInitialMessage();

    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);
  }

  static Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
    String title = message.notification?.title ?? message.data["title"] ?? "";
    String body = message.notification?.body ?? message.data["body"] ?? "";
    String? image = message.data["image"];

    // Notification handling logic...
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
