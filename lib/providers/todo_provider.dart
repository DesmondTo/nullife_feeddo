import 'package:nullife_feeddo/models/todo_model.dart';
import 'package:nullife_feeddo/models/todo_weekly_data.dart';
import 'package:nullife_feeddo/todo_firebase_api.dart';
import 'package:flutter/cupertino.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  DateTime _selectedDate = DateTime.now();

  List<Todo> get todos => _todos.where((todo) => todo.isDone == false).toList();

  List<Todo> get todosCompleted =>
      _todos.where((todo) => todo.isDone == true).toList();

  List<Todo> todosByCategory({
    required String category,
    required bool isCompleted,
  }) =>
      _todos
          .where(
              (todo) => todo.isDone == isCompleted && todo.category == category)
          .toList();

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

  // The following methods are used to compute the doughnut chart in dashboard page
  double completedPercentageByCategory(String category) {
    int completedNum =
        todosByCategory(category: category, isCompleted: true).length;
    int totalByCategory =
        todosByCategory(category: category, isCompleted: false).length +
            completedNum;
    return completedNum == 0 ? 0 : completedNum * 100 / totalByCategory;
  }

  List<TodoWeeklyData> computeChartData(List<String> categoryList) {
    return categoryList.fold(<TodoWeeklyData>[],
        (List<TodoWeeklyData> prevList, String category) {
      prevList.add(TodoWeeklyData(category, computeDuration(category)));
      return prevList;
    });
  }

  double computeDuration(String category) {
    int completedDuration = _todos.fold(
        0,
        (int prevDuration, Todo todo) =>
            prevDuration +
            (completedWithinWeekByCategory(category, todo)
                ? todo.to.difference(todo.from).inMinutes
                : 0));
    return completedDuration / 60;
  }

  bool completedWithinWeekByCategory(String category, Todo todo) {
    if (category != todo.category || !todo.isDone) return false;

    int currentWeekDay = DateTime.now().weekday;
    int startDay = DateTime.now().day - currentWeekDay + 1;
    int endDay = DateTime.now().day + 7 - currentWeekDay;
    DateTime todoDateTime = todo.from;

    return todoDateTime.year == DateTime.now().year &&
        todoDateTime.month == DateTime.now().month &&
        (todoDateTime.day >= startDay && todoDateTime.day <= endDay);
  }
}
