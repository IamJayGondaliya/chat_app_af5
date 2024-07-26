import 'package:chat_app_af5/models/user_model.dart';
import 'package:chat_app_af5/services/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/chat_model.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        ModalRoute.of(context)!.settings.arguments as UserModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(userModel.email),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream:
                    FireStoreService.instance.getChats(userModel: userModel),
                builder: (context, snapShots) {
                  if (snapShots.hasData) {
                    List<ChatModel> chats = snapShots.data?.docs
                            .map(
                              (e) => ChatModel.fromMap(
                                e.data(),
                              ),
                            )
                            .toList() ??
                        [];

                    return ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (c, i) {
                        ChatModel chat = chats[i];

                        if (chat.type == 'received') {
                          FireStoreService.instance.seenMsg(
                            user: userModel,
                            chat: chat,
                          );
                        }

                        return Row(
                          mainAxisAlignment: chat.type == "sent"
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Update !!"),
                                    content: TextFormField(
                                      initialValue: chat.msg,
                                      onChanged: (val) {
                                        chat.msg = val;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () {
                                          FireStoreService.instance
                                              .deleteMsg(userModel, chat)
                                              .then(
                                                (value) =>
                                                    Navigator.pop(context),
                                              );
                                        },
                                        child: const Text("DELETE"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          FireStoreService.instance
                                              .updateMsg(userModel, chat)
                                              .then(
                                                (value) =>
                                                    Navigator.pop(context),
                                              );
                                        },
                                        child: const Text("DONE"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.sizeOf(context).width * 0.7,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.only(
                                    bottom: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    chat.msg,
                                    style: TextStyle(
                                      color: chat.type == 'sent'
                                          ? chat.status == 'seen'
                                              ? Colors.blue
                                              : null
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
            TextField(
              controller: controller,
              onSubmitted: (val) {
                FireStoreService.instance
                    .sendMsg(
                      user: userModel,
                      chat: ChatModel(
                        DateTime.now(),
                        controller.text,
                        'sent',
                        'unseen',
                      ),
                    )
                    .then(
                      (value) => controller.clear(),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
