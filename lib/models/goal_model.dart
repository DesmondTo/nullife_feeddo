import 'package:nullife_feeddo/utils.dart';

class GoalField {
  static const createdTime = 'createdTime';
}

class Goal {
  String? userId;
  DateTime createdTime;
  String id;
  int hour;
  int minute;
  String category;

  Goal({
    required this.userId,
    required this.createdTime,
    required this.id,
    required this.hour,
    required this.minute,
    required this.category,
  });

  static Goal fromJson(Map<String, dynamic> json) => Goal(
        userId: json['userId'],
        createdTime: Utils.toDateTime(json['createdTime']),
        id: json['id'],
        category: json['category'],
        hour: json['hour'],
        minute: json['minute'],
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'createdTime': Utils.fromDateTimeToJson(createdTime),
        'id': id,
        'category': category,
        'hour': hour,
        'minute': minute,
      };
}
