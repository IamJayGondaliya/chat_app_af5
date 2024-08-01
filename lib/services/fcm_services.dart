import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

class FcmServices {
  FcmServices._();
  static final FcmServices instance = FcmServices._();

  Future<void> init() async {
    String? token = await FirebaseMessaging.instance.getToken();

    Logger().i("FCM Token: $token");

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    Logger().i('User granted permission: ${settings.authorizationStatus}');

    handleForeground();
  }

  void handleForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Logger().i('Got a message whilst in the foreground!');
      Logger().i('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}
