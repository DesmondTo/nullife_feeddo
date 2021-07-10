import 'package:nullife_feeddo/providers/todo_provider.dart';
import 'package:nullife_feeddo/widgets/todos_widget_folder/todo_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CompletedListWidget extends StatelessWidget {
  final String category;

  CompletedListWidget({required this.category});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    final todos =
        provider.todosByCategory(category: category, isCompleted: true);

    return todos.isEmpty
        ? Center(
            child: Text(
              'No completed tasks.',
              style: TextStyle(fontSize: 20),
            ),
          )
        : ListView.separated(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(16),
            separatorBuilder: (context, index) => Container(height: 8),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              return index == 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Completed',
                          style: GoogleFonts.boogaloo(
                            fontSize: 24,
                            color: Color(0xff5C6947),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TodoWidget(todo: todo),
                      ],
                    )
                  : TodoWidget(todo: todo);
            },
          );
  }
}
