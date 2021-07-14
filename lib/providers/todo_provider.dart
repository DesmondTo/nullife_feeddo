import 'package:nullife_feeddo/models/todo_model.dart';
import 'package:nullife_feeddo/todo_firebase_api.dart';
import 'package:flutter/cupertino.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  DateTime _selectedDate = DateTime.now();

  List<Todo> get todos => _todos.where((todo) => todo.isDone == false).toList();

  List<Todo> get todosCompleted =>
      _todos.where((todo) => todo.isDone == true).toList();

  List<Todo> todosByCategory(
          {required String category, required bool isCompleted}) =>
      _todos
          .where(
              (todo) => todo.isDone == isCompleted && todo.category == category)
          .toList();

  double completedPercentageByCategory(String category) {
    int completedNum =
        todosByCategory(category: category, isCompleted: true).length;
    int totalByCategory =
        todosByCategory(category: category, isCompleted: false).length +
            completedNum;
    return completedNum == 0 ? 0 : completedNum * 100 / totalByCategory;
  }

  void setTodos(List<Todo> todos) =>
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _todos = todos;
        notifyListeners();
      });

  DateTime get selectedDate => _selectedDate;

  List<Todo> get todosOfSelectedDate => _todos;

  void setDate(DateTime date) => _selectedDate = date;

  void addTodo(Todo todo) {
    _todos.add(todo);
    TodoFirebaseApi.createTodo(todo);

    notifyListeners();
  }

  void removeTodo(Todo todo) {
    TodoFirebaseApi.deleteTodo(todo);
    _todos.remove(todo);

    notifyListeners();
  }

  void removeTodoByCategory(String category) {
    for (Todo todo in _todos) {
      if (todo.category == category) {
        TodoFirebaseApi.deleteTodo(todo);
      }
    }
    _todos.removeWhere((todo) => todo.category == category);
    notifyListeners();
  }

  bool toggleTodoStatus(Todo todo) {
    todo.isDone = !todo.isDone;
    TodoFirebaseApi.updateTodo(todo);
    return todo.isDone;
  }

  void editTodo(Todo newTodo, Todo oldTodo) {
    final index = _todos.indexWhere((element) => element.id == oldTodo.id);
    _todos[index] = newTodo;
    TodoFirebaseApi.updateTodo(newTodo);

    notifyListeners();
  }
}
