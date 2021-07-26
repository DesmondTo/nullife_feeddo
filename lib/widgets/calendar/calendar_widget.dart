import 'package:firebase_auth/firebase_auth.dart';
import 'package:nullife_feeddo/models/todo_data_source.dart';
import 'package:nullife_feeddo/models/todo_model.dart';
import 'package:nullife_feeddo/providers/todo_provider.dart';
import 'package:nullife_feeddo/todo_firebase_api.dart';
import 'package:nullife_feeddo/utils.dart';
import 'package:nullife_feeddo/widgets/calendar/tasks_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

double _timegap = 0.10;

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    int currentHour = DateTime.now().hour;

    return StreamBuilder<List<Todo>>(
        stream:
            TodoFirebaseApi.readTodos(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                print('The error is: ' + snapshot.error.toString());
                return Center(
                  child: Text(
                    'Something went wrong, please try again later' +
                        '\n${snapshot.error.toString()}',
                  ),
                );
              } else {
                final List<Todo>? todos = snapshot.data;

                final provider =
                    Provider.of<TodoProvider>(context, listen: false);
                provider.setTodos(todos!);
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
                    Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).size.height / 8,
                          left: -MediaQuery.of(context).size.width / 20,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                              shape: BoxShape.rectangle,
                              color: currentHour >= 6 && currentHour < 12
                                  ? Color.fromRGBO(16, 77, 95, 0.3)
                                  : currentHour >= 12 && currentHour < 17
                                      ? Color.fromRGBO(255, 111, 65, 0.3)
                                      : currentHour >= 17 && currentHour < 19
                                          ? Color.fromRGBO(95, 75, 113, 0.4)
                                          : Color.fromRGBO(72, 94, 117, 0.4),
                            ),
                          ),
                        ),
                        SfCalendar(
                          view: CalendarView.day,
                          showCurrentTimeIndicator: true,
                          showDatePickerButton: true,
                          backgroundColor: Colors.transparent,
                          dataSource: TodoDataSource(provider.todos),
                          todayTextStyle: GoogleFonts.boogaloo(),
                          headerStyle: CalendarHeaderStyle(
                            backgroundColor: Colors.transparent,
                            textStyle: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.03,
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
                          headerHeight:
                              MediaQuery.of(context).size.height * 0.15,
                          timeSlotViewSettings: TimeSlotViewSettings(
                            timeTextStyle: GoogleFonts.boogaloo(
                              color: Colors.black,
                            ),
                            timeIntervalHeight:
                                MediaQuery.of(context).size.height * _timegap,
                          ),
                          initialSelectedDate: DateTime.now(),
                          cellBorderColor: Colors.transparent,
                          appointmentBuilder: appointmentBuilder,
                          onLongPress: (details) {
                            final provider = Provider.of<TodoProvider>(context,
                                listen: false);

                            provider.setDate(details.date!);
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => TasksWidget(),
                            );
                          },
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height / 6,
                          right: MediaQuery.of(context).size.width / 13,
                          child: Container(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.zoom_in_rounded),
                                  color: currentHour >= 6 && currentHour < 12
                                      ? Color.fromRGBO(16, 77, 95, 1)
                                      : currentHour >= 12 && currentHour < 17
                                          ? Color.fromRGBO(255, 111, 65, 1)
                                          : currentHour >= 17 &&
                                                  currentHour < 19
                                              ? Color.fromRGBO(95, 75, 113, 1)
                                              : Color.fromRGBO(72, 94, 117, 1),
                                  onPressed: () {
                                    setState(() {
                                      if (_timegap <= 1) {
                                        _timegap = _timegap + 0.25;
                                      } else {
                                        _timegap = _timegap;
                                      }
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.zoom_out_rounded),
                                  color: currentHour >= 6 && currentHour < 12
                                      ? Color.fromRGBO(16, 77, 95, 1)
                                      : currentHour >= 12 && currentHour < 17
                                          ? Color.fromRGBO(255, 111, 65, 1)
                                          : currentHour >= 17 &&
                                                  currentHour < 19
                                              ? Color.fromRGBO(95, 75, 113, 1)
                                              : Color.fromRGBO(72, 94, 117, 1),
                                  onPressed: () {
                                    setState(() {
                                      if (_timegap >= 0.25) {
                                        _timegap = _timegap - 0.25;
                                      } else {
                                        _timegap = 0.1;
                                      }
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.restore),
                                  color: currentHour >= 6 && currentHour < 12
                                      ? Color.fromRGBO(16, 77, 95, 1)
                                      : currentHour >= 12 && currentHour < 17
                                          ? Color.fromRGBO(255, 111, 65, 1)
                                          : currentHour >= 17 &&
                                                  currentHour < 19
                                              ? Color.fromRGBO(95, 75, 113, 1)
                                              : Color.fromRGBO(72, 94, 117, 1),
                                  onPressed: () {
                                    setState(() {
                                      _timegap = _timegap - 0.25;
                                      _timegap = 0.1;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
          }
        });
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
                  ? details.bounds.height * 0.7
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
            todo.to.difference(todo.from).inMinutes <= 10
                ? Container(
                    height: details.bounds.height * 0.2,
                    padding: EdgeInsets.fromLTRB(3, 5, 3, 2),
                    color: todo.backgroundColor.withOpacity(0.8),
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.description,
                          style: GoogleFonts.boogaloo(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        )
                      ],
                    )),
                  )
                : Container(
                    height: details.bounds.height * 0.6,
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
