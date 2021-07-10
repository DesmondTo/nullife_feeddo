import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nullife_feeddo/models/todo_model.dart';
import 'package:nullife_feeddo/utils.dart';

class TodoFirebaseApi {
  static Future<String> createTodo(Todo todo) async {
    final docTodo = FirebaseFirestore.instance.collection('todo').doc();

    todo.id = docTodo.id;
    await docTodo.set(todo.toJson());

    return docTodo.id;
  }

  static Stream<List<Todo>> readTodos(String userId) =>
      FirebaseFirestore.instance
          .collection('todo')
          .orderBy(TodoField.createdTime, descending: true)
          .where('userId', isEqualTo: userId)
          .snapshots()
          .transform(Utils.transformer(Todo.fromJson));

  static Future updateTodo(Todo todo) async {
    final docTodo = FirebaseFirestore.instance.collection('todo').doc(todo.id);

    await docTodo.update(todo.toJson());
  }

  static Future deleteTodo(Todo todo) async {
    final docTodo = FirebaseFirestore.instance.collection('todo').doc(todo.id);

    await docTodo.delete();
  }
}
