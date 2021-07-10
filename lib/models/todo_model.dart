import 'package:nullife_feeddo/utils.dart';
import 'package:flutter/material.dart';

class TodoField {
  static const createdTime = 'createdTime';
  static const from = 'from';
  static const to = 'to';
}

class Todo {
  String? userId;
  DateTime createdTime;
  String id;
  final DateTime from;
  final DateTime to;
  String title;
  String description;
  bool isDone;
  String category;
  final bool isAllDay;
  final Color backgroundColor;

  Todo({
    required this.userId,
    required this.createdTime,
    required this.id,
    required this.from,
    required this.to,
    required this.title,
    required this.category,
    required this.backgroundColor,
    this.description = '',
    this.isDone = false,
    this.isAllDay = false,
  });

  static Todo fromJson(Map<String, dynamic> json) => Todo(
        userId: json['userId'],
        createdTime: Utils.toDateTime(json['createdTime']),
        id: json['id'],
        from: Utils.toDateTime(json['from']),
        to: Utils.toDateTime(json['to']),
        category: json['category'],
        title: json['title'],
        description: json['description'],
        isDone: json['isDone'],
        isAllDay: json['isAllDay'],
        backgroundColor: Utils.toColor(json['backgroundColor']),
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'createdTime': Utils.fromDateTimeToJson(createdTime),
        'id': id,
        'from': Utils.fromDateTimeToJson(from),
        'to': Utils.fromDateTimeToJson(to),
        'category': category,
        'title': title,
        'description': description,
        'isDone': isDone,
        'isAllDay': isAllDay,
        'backgroundColor': Utils.fromColor(this.backgroundColor),
      };
}
