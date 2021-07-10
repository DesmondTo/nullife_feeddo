import 'package:nullife_feeddo/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TodoDataSource extends CalendarDataSource {
  TodoDataSource(List<Todo> appointments) {
    this.appointments = appointments;
  }

  Todo getTodo(int index) => appointments![index] as Todo;

  @override
  DateTime getStartTime(int index) => getTodo(index).from;

  @override
  DateTime getEndTime(int index) => getTodo(index).to;

  @override
  String getSubject(int index) => getTodo(index).title;

  @override
  bool isAllDay(int index) => getTodo(index).isAllDay;

  @override
  Color getColor(int index) => getTodo(index).backgroundColor;

  @override
  String? getNotes(int index) => getTodo(index).description;
}
