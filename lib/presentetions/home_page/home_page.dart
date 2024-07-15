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
      appBar: AppBar(
        title: Text(
          AuthService.instance.auth.currentUser?.displayName ?? "No User",
        ),
        actions: [
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
            stream: FireStoreService.instance.getStream(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snaps) {
              if (snaps.hasData) {
                QuerySnapshot? snapData = snaps.data;
                List<QueryDocumentSnapshot> allDocs = snapData?.docs ?? [];

                List<TodoModel> allTodos = allDocs
                    .map(
                      (e) => TodoModel.fromMap(e.data() as Map),
                    )
                    .toList();

                return ListView.builder(
                  itemCount: allTodos.length,
                  itemBuilder: (c, i) => Card(
                    child: ListTile(
                      title: Text(allTodos[i].title),
                      leading: Text(allTodos[i].id),
                      subtitle: Text(allTodos[i].dTime.toString()),
                      trailing: Checkbox(
                        value: allTodos[i].status,
                        onChanged: (val) {
                          allTodos[i].status = val ?? false;

                          FireStoreService.instance.updateStatus(
                            todoModel: allTodos[i],
                          );
                        },
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FireStoreService.instance.addTodo(
            todoModel: TodoModel(
              "105",
              "Again Data",
              false,
              15126532,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
