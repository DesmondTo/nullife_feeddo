import 'package:nullife_feeddo/models/todo_data_source.dart';
import 'package:nullife_feeddo/models/todo_model.dart';
import 'package:nullife_feeddo/providers/todo_provider.dart';
import 'package:nullife_feeddo/utils.dart';
import 'package:nullife_feeddo/widgets/calendar/tasks_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<TodoProvider>(context).todos;
    int currentHour = DateTime.now().hour;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Material(
          elevation: 10,
          shadowColor: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              currentHour >= 6 && currentHour < 12
                  ? 'assets/images/schedule_screen_morning_bg.jpg'
                  : currentHour >= 12 && currentHour < 17
                      ? 'assets/images/schedule_screen_afternoon_bg.jpg'
                      : currentHour >= 17 && currentHour < 19
                          ? 'assets/images/schedule_screen_evening_bg.jpg'
                          : 'assets/images/schedule_screen_night_bg.jpg',
              fit: BoxFit.fitWidth,
            ),
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 5.0,
                ),
              ],
            ),
          ),
        ),
        SfCalendar(
          view: CalendarView.day,
          showCurrentTimeIndicator: true,
          backgroundColor: Colors.transparent,
          dataSource: TodoDataSource(todos),
          todayTextStyle: GoogleFonts.boogaloo(),
          headerStyle: CalendarHeaderStyle(
            backgroundColor: Colors.transparent,
            textStyle: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * 0.05,
              color: currentHour >= 6 && currentHour < 12
                  ? Colors.black
                  : Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          viewHeaderStyle: ViewHeaderStyle(
            dateTextStyle: GoogleFonts.boogaloo(
              color: Colors.black,
            ),
            dayTextStyle: GoogleFonts.boogaloo(
              color: Colors.black,
            ),
          ),
          headerHeight: MediaQuery.of(context).size.height * 0.15,
          timeSlotViewSettings: TimeSlotViewSettings(
            timeTextStyle: GoogleFonts.boogaloo(
              color: Colors.black,
            ),
            timeIntervalHeight: MediaQuery.of(context).size.height * 0.1,
          ),
          initialSelectedDate: DateTime.now(),
          cellBorderColor: Colors.transparent,
          appointmentBuilder: appointmentBuilder,
          onLongPress: (details) {
            final provider = Provider.of<TodoProvider>(context, listen: false);

            provider.setDate(details.date!);
            showModalBottomSheet(
              context: context,
              builder: (context) => TasksWidget(),
            );
          },
        ),
      ],
    );
  }

  Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    CalendarController _controller = CalendarController();
    final Todo todo = details.appointments.first;
    if (_controller.view != CalendarView.month &&
        _controller.view != CalendarView.schedule) {
      return Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(3),
              height: todo.to.difference(todo.from).inMinutes <= 10
                  ? details.bounds.height * 0.8
                  : details.bounds.height * 0.3,
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                color: todo.backgroundColor,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      todo.title,
                      style: GoogleFonts.boogaloo(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Start: ',
                            style: GoogleFonts.boogaloo(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                          TextSpan(
                            text:
                                '${DateFormat('hh:mm a').format(todo.from)} \n',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                          TextSpan(
                            text: 'End:   ',
                            style: GoogleFonts.boogaloo(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                          TextSpan(
                            text: '${DateFormat('hh:mm a').format(todo.to)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: todo.to.difference(todo.from).inMinutes <= 10
                  ? details.bounds.height * 0.1
                  : details.bounds.height * 0.6,
              padding: EdgeInsets.fromLTRB(3, 5, 3, 2),
              color: todo.backgroundColor.withOpacity(0.8),
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Utils.toCategorySVG(
                      category: todo.category,
                      width: details.bounds.width,
                    ),
                  ),
                  Text(
                    todo.description,
                    style: GoogleFonts.boogaloo(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  )
                ],
              )),
            ),
            Container(
              height: details.bounds.height * 0.1,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                color: todo.backgroundColor,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      child: Text(todo.description),
    );
  }
}
