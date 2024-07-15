import 'package:chat_app_af5/models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  FireStoreService._();
  static final FireStoreService instance = FireStoreService._();

  // Initialize
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  String collectionPath = "Todo";

  // Add data
  Future<void> addTodo({required TodoModel todoModel}) async {
    // // Auto ID
    // await fireStore.collection(collectionPath).add(
    //       todoModel.toMap,
    //     );

    // Custom ID
    await fireStore.collection(collectionPath).doc(todoModel.id).set(
          todoModel.toMap,
        );
  }

  Future<List<TodoModel>> getData() async {
    List<TodoModel> allTodos = [];

    // Get snapShots
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await fireStore.collection(collectionPath).get();

    // Get Docs
    List<QueryDocumentSnapshot> docs = snapshot.docs;

    // Parse data
    allTodos = docs
        .map(
          (e) => TodoModel.fromMap(e.data() as Map),
        )
        .toList();

    return allTodos;
  }

  // Data stream
  Stream<QuerySnapshot<Map<String, dynamic>>> getStream() {
    return fireStore.collection(collectionPath).snapshots();
  }

  // Data Update
  Future<void> updateStatus({required TodoModel todoModel}) async {
    await fireStore
        .collection(collectionPath)
        .doc(todoModel.id)
        .update(todoModel.toMap);
  }
}
