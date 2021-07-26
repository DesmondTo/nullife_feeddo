import 'package:nullife_feeddo/models/todo_model.dart';
import 'package:nullife_feeddo/providers/todo_provider.dart';
import 'package:nullife_feeddo/screens/todo_screen_folder/edit_todo_screen.dart';
import 'package:nullife_feeddo/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class TodoWidget extends StatelessWidget {
  final Todo todo;

  const TodoWidget({
    required this.todo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          key: Key(todo.id),
          actions: [
            IconSlideAction(
              color: Colors.green,
              onTap: () => editTodo(context, todo),
              caption: 'Edit',
              icon: Icons.edit,
            )
          ],
          secondaryActions: [
            IconSlideAction(
              color: Colors.red,
              caption: 'Delete',
              onTap: () => deleteTodo(context, todo),
              icon: Icons.delete,
            )
          ],
          child: Container(
            margin: const EdgeInsets.only(bottom: 6.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xff5C6947),
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0xff5C6947),
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: buildTodo(context),
          ),
        ),
      );

  Widget buildTodo(BuildContext context) => GestureDetector(
        onTap: () => editTodo(context, todo),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Checkbox(
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.black,
                    width: 4,
                  ),
                ),
                checkColor: Colors.white,
                activeColor: Colors.black,
                value: todo.isDone,
                onChanged: (_) {
                  final provider =
                      Provider.of<TodoProvider>(context, listen: false);
                  provider.toggleTodoStatus(todo, context);
                },
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff5C6947),
                        fontSize: 22,
                      ),
                    ),
                    if (todo.description.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        child: Text(
                          todo.description,
                          style: TextStyle(fontSize: 20, height: 1.5),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  void deleteTodo(BuildContext context, Todo todo) {
    final provider = Provider.of<TodoProvider>(context, listen: false);
    provider.removeTodo(todo);

    Utils.showSnackBar(context, 'Deleted the task');
  }

  void editTodo(BuildContext context, Todo todo) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TodoEditingScreen(
            bgColor: todo.backgroundColor,
            todo: todo,
            category: todo.category,
          ),
        ),
      );
}
