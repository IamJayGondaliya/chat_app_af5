import 'package:chat_app_af5/models/user_model.dart';
import 'package:chat_app_af5/services/firestore_service.dart';
import 'package:flutter/material.dart';

class MyFriends extends StatelessWidget {
  const MyFriends({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Friends"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: FireStoreService.instance.getFriendsStream(),
          builder: (c, snap) {
            if (snap.hasData) {
              List<UserModel> friends = snap.data?.docs
                      .map((e) => UserModel.froMap(e.data()))
                      .toList() ??
                  [];

              return friends.isEmpty
                  ? const Center(
                      child: Text("You have no friends !!"),
                    )
                  : ListView.builder(
                      itemCount: friends.length,
                      itemBuilder: (c, i) {
                        UserModel userModel = friends[i];

                        return ListTile(
                          leading: CircleAvatar(
                            foregroundImage: NetworkImage(userModel.photoURL),
                          ),
                          title: Text(userModel.displayName),
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
