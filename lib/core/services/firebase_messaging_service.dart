import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:exim_lab/core/services/shared_pref_service.dart';
import 'package:exim_lab/core/services/notification_router.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> setupFirebase() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> setupTokenSync() async {
    _firebaseMessaging.onTokenRefresh.listen((token) async {
      await SharedPrefService().saveFcmToken(token);
    });
  }

  Future<String?> getFirebaseToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await SharedPrefService().saveFcmToken(token);
      }
      return token;
    } catch (e) {
      return null;
    }
  }

  Future<void> subsScribetoAlltopic() async {
    try {
      await _firebaseMessaging.subscribeToTopic("live");
    } catch (e) {
      // ignore
    }
  }

  /// Wire notification-tap navigation (call once after runApp).
  ///
  /// - System-tray FCM tap while app in background → onMessageOpenedApp
  /// - App launched from a terminated state via FCM tap → getInitialMessage
  ///   (routed after a delay so Splash finishes its own navigation first)
  Future<void> setupInteractedMessage() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      NotificationRouter.routeFromData(message.data);
    });

    final RemoteMessage? initial = await _firebaseMessaging.getInitialMessage();
    if (initial != null && initial.data.isNotEmpty) {
      // Splash takes ~2s + navigation; route on top of the landing screen.
      Future.delayed(const Duration(seconds: 4), () {
        NotificationRouter.routeFromData(initial.data);
      });
    }
  }

  Future<void> initPushNotifications() async {
    await _firebaseMessaging.getInitialMessage();

    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

    // 🔔 FOREGROUND HANDLING (ADD THIS)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      firebaseBackgroundMessage(message);
    });
  }

  static Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
    String title = message.notification?.title ?? message.data["title"] ?? "";
    String body = message.notification?.body ?? message.data["body"] ?? "";
    String? image = message.data["image"];

    // Carry the FCM data into the local notification so a tap can route
    // (e.g. type=news + newsId → news details screen).
    final Map<String, String?> payload = message.data.map(
      (key, value) => MapEntry(key, value?.toString()),
    );

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
            payload: payload,
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
            payload: payload,
          ),
        );
      }
    }
  }
}
