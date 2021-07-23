import 'package:nullife_feeddo/models/todo_data_source.dart';
import 'package:nullife_feeddo/providers/todo_provider.dart';
import 'package:nullife_feeddo/screens/todo_screen_folder/edit_todo_screen.dart';
import 'package:nullife_feeddo/screens/todo_screen_folder/view_todo_screen.dart';
import 'package:nullife_feeddo/widgets/todos_widget_folder/completed_list_widget.dart';
import 'package:nullife_feeddo/widgets/todos_widget_folder/todo_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TodoListWidget extends StatelessWidget {
  final Color bgColor;
  final String category;

  TodoListWidget({
    required this.bgColor,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    final todos =
        provider.todosByCategory(category: category, isCompleted: false);
    final completedTodos =
        provider.todosByCategory(category: category, isCompleted: true);

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Material(
                        elevation: 5,
                        child: Container(
                          color: bgColor,
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: SingleChildScrollView(
                              child: Text(
                                this.category,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.075,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: SfCalendar(
                                view: CalendarView.timelineDay,
                                dataSource: TodoDataSource(provider.todos
                                    .where((todo) => todo.category == category)
                                    .toList()),
                                initialDisplayDate: provider.selectedDate,
                                appointmentBuilder: appointmentBuilder,
                                backgroundColor: Colors.white,
                                headerHeight: 0,
                                viewHeaderHeight: 0,
                                viewHeaderStyle: ViewHeaderStyle(
                                    backgroundColor: Colors.transparent),
                                cellBorderColor: Colors.transparent,
                                todayHighlightColor: Colors.black,
                                selectionDecoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                onTap: (details) {
                                  if (details.appointments == null) return;

                                  final todo = details.appointments!.first;

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TodoViewingScreen(todo: todo)));
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: todos.isEmpty
                      ? CompletedListWidget(category: this.category)
                      : ListView.separated(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.all(16),
                          separatorBuilder: (context, index) =>
                              Container(height: 8),
                          itemCount: todos.length + completedTodos.length,
                          itemBuilder: (context, index) {
                            if (index <= todos.length - 1) {
                              return TodoWidget(todo: todos[index]);
                            } else if (index == todos.length) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Completed',
                                    style: GoogleFonts.boogaloo(
                                      fontSize: 24,
                                      color: Color(0xff5C6947),
                                    ),
                                  ),
                                  TodoWidget(
                                      todo:
                                          completedTodos[index - todos.length]),
                                ],
                              );
                            } else {
                              return TodoWidget(
                                  todo: completedTodos[index - todos.length]);
                            }
                          },
                        ),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.black,
            onPressed: () => showDialog(
              context: context,
              builder: (context) =>
                  TodoEditingScreen(bgColor: bgColor, category: this.category),
              barrierDismissible: false,
            ),
            child: Icon(Icons.add),
          )),
    );
  }

  Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final todo = details.appointments.first;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: todo.backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          todo.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
