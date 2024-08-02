import 'package:chat_app_af5/models/todo_model.dart';
import 'package:chat_app_af5/services/auth_services.dart';
import 'package:chat_app_af5/services/firestore_service.dart';
import 'package:chat_app_af5/services/notification_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppLifecycleListener _listener;
  // late AppLifecycleState _state;

  @override
  void initState() {
    // _state = SchedulerBinding.instance.lifecycleState!;
    // Logger().i("STATE: ${_state.name}");

    _listener = AppLifecycleListener(
      onResume: () {
        Logger().i("USER ENTERED...");
      },
      onPause: () {
        Logger().i("USER EXITED...");
      },
    );

    NotificationServices.instance.request();

    super.initState();
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                foregroundImage: NetworkImage(
                  FireStoreService.instance.currentUser!.photoURL,
                ),
              ),
              accountName:
                  Text(FireStoreService.instance.currentUser!.displayName),
              accountEmail: Text(FireStoreService.instance.currentUser!.email),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("My friends"),
              trailing: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('friends');
                },
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          AuthService.instance.auth.currentUser!?.displayName ?? "No User",
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('all_users');
            },
            icon: const Icon(Icons.people),
          ),
          IconButton(
            onPressed: () {
              AuthService.instance.logOut().then((value) {
                Navigator.of(context).pushReplacementNamed('/');
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                NotificationServices.instance
                    .simpleNotification(title: "LOCAL");
              },
              child: const Text("Simple Notification"),
            ),
            ElevatedButton(
              onPressed: () {
                NotificationServices.instance.scheduledNotification();
              },
              child: const Text("Scheduled Notification"),
            ),
            ElevatedButton(
              onPressed: () {
                NotificationServices.instance.bigPictureNotification();
              },
              child: const Text("Big Picture Notification"),
            ),
            ElevatedButton(
              onPressed: () {
                NotificationServices.instance.mediaStyleNotification();
              },
              child: const Text("Media Style Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
