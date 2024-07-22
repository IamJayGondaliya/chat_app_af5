import 'package:chat_app_af5/models/user_model.dart';
import 'package:chat_app_af5/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllUsersPage extends StatelessWidget {
  const AllUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Users"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: FireStoreService.instance.getAllUsers(),
          builder: (context, snaps) {
            if (snaps.hasData) {
              List<UserModel> allUsers = snaps.data?.docs
                      .map((e) => UserModel.froMap(e.data()))
                      .toList() ??
                  [];

              allUsers.removeWhere((element) =>
                  element.uid == FireStoreService.instance.currentUser!.uid);

              return ListView.separated(
                separatorBuilder: (c, i) => const Divider(),
                itemCount: allUsers.length,
                itemBuilder: (c, i) {
                  UserModel user = allUsers[i];

                  return ListTile(
                    leading: CircleAvatar(
                      foregroundImage: NetworkImage(user.photoURL),
                    ),
                    title: Text(user.displayName),
                    subtitle: Text(user.email),
                    trailing: IconButton(
                      onPressed: () {
                        FireStoreService.instance.addFriend(userModel: user);
                      },
                      icon: const Icon(Icons.person_add),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
