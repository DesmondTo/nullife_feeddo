import 'package:nullife_feeddo/models/todo_model.dart';
import 'package:nullife_feeddo/providers/todo_provider.dart';
import 'package:nullife_feeddo/utils.dart';
import 'package:nullife_feeddo/widgets/time_zone/timeZone.dart';
import 'package:nullife_feeddo/widgets/todos_widget_folder/edit_todo_widget/description_textform_widget.dart';
import 'package:nullife_feeddo/widgets/todos_widget_folder/edit_todo_widget/title_textform_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../main.dart';

class TodoEditingScreen extends StatefulWidget {
  final Todo? todo;
  final Color bgColor;
  final String category;

  const TodoEditingScreen({
    Key? key,
    this.todo,
    required this.bgColor,
    required this.category,
  }) : super(key: key);

  @override
  _TodoEditingScreenState createState() =>
      _TodoEditingScreenState(category: this.category);
}

class _TodoEditingScreenState extends State<TodoEditingScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final String category;
  late DateTime createdTime;
  late DateTime fromDate;
  late DateTime toDate;
  late bool isDone;
  late bool isAllDay;
  late String dropdownValue;
  late List<String> dropdownList;

  _TodoEditingScreenState({required this.category});

  @override
  void initState() {
    super.initState();

    if (widget.todo == null) {
      createdTime = DateTime.now();
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
      isDone = false;
      isAllDay = false;
    } else {
      final todo = widget.todo!;

      titleController.text = todo.title;
      descriptionController.text = todo.description;
      createdTime = todo.createdTime;
      fromDate = todo.from;
      toDate = todo.to;
      isDone = todo.isDone;
      isAllDay = todo.isAllDay;
    }
    dropdownValue =
        fromDate.subtract(Duration(minutes: 10)).isBefore(DateTime.now())
            ? '<10 minutes'
            : '10 minutes';
    dropdownList =
        fromDate.subtract(Duration(minutes: 10)).isBefore(DateTime.now())
            ? <String>['<10 minutes']
            : fromDate.subtract(Duration(hours: 1)).isBefore(DateTime.now())
                ? <String>['10 minutes']
                : fromDate.subtract(Duration(days: 1)).isBefore(DateTime.now())
                    ? <String>['10 minutes', '1 hours']
                    : <String>['10 minutes', '1 hour', '1 day'];
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: buildEditingActions(),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleTextFormWidget(titleController: titleController),
                SizedBox(
                  height: 12,
                ),
                buidDateTimePickers(),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Reminds me ',
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: dropdownList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Text(
                      'before the task starts',
                    )
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                DescriptionTextFormWidget(
                    descriptionController: descriptionController),
              ],
            ),
          )),
    );
  }

  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: saveForm,
          icon: Icon(
            Icons.done,
          ),
          label: Text(
            'SAVE',
          ),
        ),
      ];

  Widget buidDateTimePickers() => Column(
        children: [
          buildFromToHeader(true),
          buildFromToHeader(false),
        ],
      );

  Widget buildFromToHeader(bool isFrom) => buildHeader(
        header: isFrom ? 'From' : 'To',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                text: Utils.toDateString(isFrom ? fromDate : toDate),
                onClicked: () =>
                    pickFromToDateTime(isFrom: isFrom, pickDate: true),
              ),
            ),
            Expanded(
              child: buildDropdownField(
                text: Utils.toTimeString(isFrom ? fromDate : toDate),
                onClicked: () =>
                    pickFromToDateTime(isFrom: isFrom, pickDate: false),
              ),
            ),
          ],
        ),
      );

  Future pickFromToDateTime({required isFrom, required bool pickDate}) async {
    final date = await pickDateTime(
      isFrom ? fromDate : toDate,
      pickDate: pickDate,
    );
    if (date == null) return;

    if (isFrom && date.isAfter(toDate)) {
      toDate = DateTime(
          date.year, date.month, date.day, date.hour, date.minute + 10);
    }

    if (!isFrom && date.isBefore(fromDate)) {
      fromDate = DateTime(
          date.year, date.month, date.day, date.hour, date.minute - 10);
    }

    setState(() {
      if (isFrom) {
        fromDate = date;
      } else {
        toDate = date;
      }
      dropdownValue =
          fromDate.subtract(Duration(minutes: 10)).isBefore(DateTime.now())
              ? '<10 minutes'
              : '10 minutes';
      dropdownList = fromDate
              .subtract(Duration(minutes: 10))
              .isBefore(DateTime.now())
          ? <String>['<10 minutes']
          : fromDate.subtract(Duration(hours: 1)).isBefore(DateTime.now())
              ? <String>['10 minutes']
              : fromDate.subtract(Duration(days: 1)).isBefore(DateTime.now())
                  ? <String>['10 minutes', '1 hours']
                  : <String>['10 minutes', '1 hour', '1 day'];
    });
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
      );
      if (date == null) return null;

      final time = Duration(
        hours: initialDate.hour,
        minutes: initialDate.minute,
      );

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          child,
        ],
      );

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final todo = Todo(
        userId: widget.todo?.userId ?? FirebaseAuth.instance.currentUser!.uid,
        createdTime: widget.todo?.createdTime ?? DateTime.now(),
        category: category,
        backgroundColor: widget.bgColor,
        id: widget.todo?.id ?? DateTime.now().toString(),
        title: titleController.text,
        description: descriptionController.text,
        from: fromDate,
        to: toDate,
        isAllDay: false,
        isDone: widget.todo?.isDone ?? false,
      );
      scheduleAlarm();

      final isEditing = widget.todo != null;
      final provider = Provider.of<TodoProvider>(
        context,
        listen: false,
      );
      if (isEditing) {
        provider.editTodo(todo, widget.todo!);
      } else {
        provider.addTodo(todo);
      }
      Navigator.pop(context);
    }
  }

  void scheduleAlarm() async {
    final timeZone = TimeZone();

    // The device's timezone.
    String timeZoneName = await timeZone.getTimeZoneName();

    // Find the 'current location'
    final location = await timeZone.getLocation(timeZoneName);
    tz.initializeTimeZones();
    tz.setLocalLocation(location);
    final scheduleDateTime = dropdownValue == '<10 minutes'
        ? tz.TZDateTime.from(fromDate, tz.local).add(Duration(seconds: 5))
        : tz.TZDateTime.from(fromDate, tz.local)
            .subtract(Utils.toDuration(dropdownValue));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'feeddo',
      sound: RawResourceAndroidNotificationSound('slow_spring_board'),
      largeIcon: DrawableResourceAndroidBitmap('feeddo'),
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      '$dropdownValue before the task: ' + titleController.text,
      descriptionController.text,
      scheduleDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
