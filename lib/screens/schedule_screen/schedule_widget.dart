import 'package:nullife_feeddo/widgets/calendar/calendar_widget.dart';
import 'package:flutter/material.dart';

class ScheduleWidget extends StatelessWidget {
  const ScheduleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CalendarWidget(),
      ),
    );
  }
}
