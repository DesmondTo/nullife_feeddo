import 'package:nullife_feeddo/models/todo_data_source.dart';
import 'package:nullife_feeddo/providers/todo_provider.dart';
import 'package:nullife_feeddo/screens/todo_screen_folder/view_todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key}) : super(key: key);

  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    final selectedEvents = provider.todosOfSelectedDate;

    if (selectedEvents.isEmpty) {
      return Center(
        child: Text(
          'No Events found!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      );
    }

    return SfCalendarTheme(
      data: SfCalendarThemeData(
        timeTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      child: SfCalendar(
          view: CalendarView.timelineDay,
          dataSource: TodoDataSource(provider.todos),
          initialDisplayDate: provider.selectedDate,
          appointmentBuilder: appointmentBuilder,
          headerHeight: 0,
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
                    builder: (context) => TodoViewingScreen(todo: todo)));
          }),
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
