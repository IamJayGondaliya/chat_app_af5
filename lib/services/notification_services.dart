import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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

  Future<void> simpleNotification({required String title}) async {
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
          title,
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
      playSound: true,
      sound: RawResourceAndroidNotificationSound("ctdd"),
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
          matchDateTimeComponents: DateTimeComponents.time,
        )
        .then(
          (value) => Logger().i("Msg sent..."),
        )
        .onError(
          (error, stackTrace) => Logger().e("NTF ERROR: $error"),
        );
  }

  Future<void> bigPictureNotification() async {
    String url =
        "https://img.freepik.com/free-photo/painting-mountain-lake-with-mountain-background_188544-9126.jpg";
    http.Response response = await http.get(Uri.parse(url));

    Directory directory = await getApplicationSupportDirectory();
    File path = File("${directory.path}/img.png");
    path.writeAsBytesSync(response.bodyBytes);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      '101',
      'Demo channel',
      importance: Importance.max,
      priority: Priority.max,
      // largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
      largeIcon: FilePathAndroidBitmap(path.path),
      styleInformation: BigPictureStyleInformation(
        FilePathAndroidBitmap(path.path),
        hideExpandedLargeIcon: true,
      ),
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

  Future<void> mediaStyleNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      '101',
      'Demo channel',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("ctdd"),
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
}
