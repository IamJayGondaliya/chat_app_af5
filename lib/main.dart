import 'package:chat_app_af5/firebase_options.dart';
import 'package:chat_app_af5/presentetions/all_users/all_users.dart';
import 'package:chat_app_af5/presentetions/chat_page/chat_page.dart';
import 'package:chat_app_af5/presentetions/friends/friends.dart';
import 'package:chat_app_af5/presentetions/home_page/home_page.dart';
import 'package:chat_app_af5/presentetions/sign_in/sign_in_page.dart';
import 'package:chat_app_af5/services/fcm_services.dart';
import 'package:chat_app_af5/services/firestore_service.dart';
import 'package:chat_app_af5/services/notification_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:timezone/data/latest.dart' as tz;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Logger().f("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationServices.instance.initNotification();
  await FcmServices.instance.init();

  tz.initializeTimeZones();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:
          FireStoreService.instance.currentUser == null ? '/' : 'home_page',
      routes: {
        '/': (context) => const SignInPage(),
        'home_page': (context) => const HomePage(),
        'all_users': (context) => const AllUsersPage(),
        'friends': (context) => const MyFriends(),
        'chat_page': (context) => ChatPage(),
      },
    );
  }
}
