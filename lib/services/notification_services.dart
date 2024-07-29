import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  NotificationServices._();
  static final NotificationServices instance = NotificationServices._();

  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('ic_launcher');

    DarwinInitializationSettings darwinInitializationSettings =
        const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );

    await notificationsPlugin
        .initialize(initializationSettings)
        .then((value) => Logger().i("Notification initialized..."))
        .onError(
          (error, stackTrace) => Logger().e("NOTIFICATION ERROR: $error"),
        );
  }

  Future<void> request() async {
    PermissionStatus status = await Permission.notification.request();

    PermissionStatus alarmStatus =
        await Permission.scheduleExactAlarm.request();

    if (status.isDenied && alarmStatus.isDenied) {
      await request();
    }
  }

  Future<void> simpleNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      '101',
      'Demo channel',
      importance: Importance.max,
      priority: Priority.max,
    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await notificationsPlugin
        .show(
          DateTime.now().second,
          "Hyy there !!",
          "Notification sent on ${DateTime.now().hour % 12}:${DateTime.now().minute}:${DateTime.now().second}",
          notificationDetails,
        )
        .then((value) => Logger().i("Msg sent..."))
        .onError(
          (error, stackTrace) => Logger().e("NTF ERROR: $error"),
        );
  }

  Future<void> scheduledNotification() async {
    tz.initializeTimeZones();

    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      '101',
      'Demo channel',
      importance: Importance.max,
      priority: Priority.max,
    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await notificationsPlugin
        .zonedSchedule(
          101,
          "Schedule !!",
          "This is scheduled notification !!",
          tz.TZDateTime.from(
            DateTime.now().add(
              const Duration(
                seconds: 2,
              ),
            ),
            tz.local,
          ),
          notificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        )
        .then(
          (value) => Logger().i("Msg sent..."),
        )
        .onError(
          (error, stackTrace) => Logger().e("NTF ERROR: $error"),
        );
  }

  // TODO: bigPictureNotification

  // TODO: mediaStyleNotification
}
