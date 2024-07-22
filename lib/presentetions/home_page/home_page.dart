import 'package:chat_app_af5/models/todo_model.dart';
import 'package:chat_app_af5/services/auth_services.dart';
import 'package:chat_app_af5/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
    );
  }
}
