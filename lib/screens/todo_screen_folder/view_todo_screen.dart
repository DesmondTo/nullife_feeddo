import 'package:nullife_feeddo/models/todo_model.dart';
import 'package:nullife_feeddo/providers/todo_provider.dart';
import 'package:nullife_feeddo/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nullife_feeddo/screens/todo_screen_folder/edit_todo_screen.dart';

class TodoViewingScreen extends StatelessWidget {
  final Todo todo;

  const TodoViewingScreen({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        title: Text(todo.title),
        actions: buildViewingActions(context, todo),
      ),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: [
          buildDateTime(todo),
          SizedBox(
            height: 32,
          ),
          Text(
            todo.description,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            todo.description,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }

  Widget buildDateTime(Todo todo) {
    return Column(
      children: [
        buildDate(
          todo.isAllDay ? 'All-day' : 'From',
          todo.from,
        ),
        SizedBox(
          height: 12,
        ),
        if (!todo.isAllDay) buildDate('To', todo.to),
      ],
    );
  }

  Widget buildDate(String title, DateTime date) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            Utils.toDateTimeString(date),
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> buildViewingActions(BuildContext context, Todo todo) => [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TodoEditingScreen(
                  bgColor: todo.backgroundColor,
                  todo: todo,
                  category: todo.category),
            ),
          ),
        ),
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              final provider =
                  Provider.of<TodoProvider>(context, listen: false);

              provider.removeTodo(todo);
            }),
      ];
}
