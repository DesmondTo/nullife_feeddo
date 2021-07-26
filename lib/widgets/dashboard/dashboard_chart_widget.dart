import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nullife_feeddo/models/goal_model.dart';
import 'package:nullife_feeddo/models/todo_weekly_data.dart';
import 'package:nullife_feeddo/providers/todo_provider.dart';
import 'package:nullife_feeddo/utils.dart';
import 'package:nullife_feeddo/widgets/dashboard/pet_quote_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashBoardChart extends StatefulWidget {
  final List<Goal> goals;
  final List<String> categoryList;

  const DashBoardChart({
    Key? key,
    required this.goals,
    required this.categoryList,
  }) : super(key: key);

  @override
  _DashBoardChartState createState() => _DashBoardChartState();
}

class _DashBoardChartState extends State<DashBoardChart> {
  late List<TodoWeeklyData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  late TodoProvider _todoProvider;
  late List<Goal> _goals;
  late int _numOfHittedTarget;
  late double _balanceLevel;

  @override
  void initState() {
    _todoProvider = Provider.of<TodoProvider>(context, listen: false);
    _chartData = _todoProvider.computeChartData(widget.categoryList);
    _tooltipBehavior = TooltipBehavior(
      enable: true,
    );
    _goals = widget.goals;
    _numOfHittedTarget = _chartData.fold(0, (int prev, TodoWeeklyData data) {
      Goal? match;
      for (Goal goal in _goals) {
        if (goal.category == data.category) {
          match = goal;
        }
      }
      return prev +
          (match == null
              ? 0
              : ((data.duration - (match.hour + match.minute / 60)) /
                              data.duration)
                          .abs() <
                      0.35
                  ? 1
                  : 0);
    });
    _balanceLevel =
        _goals.length == 0 ? 0 : _numOfHittedTarget * 100 / _goals.length;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _chartData.removeWhere((data) => data.duration == 0);
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ClipPath(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            color: Color.fromRGBO(210, 232, 255, 1),
          ),
          clipper: MyCustomClipper(),
        ),
        Column(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text(
                    "WEEKLY DASHBOARD",
                    style: GoogleFonts.boogaloo(
                      fontSize: 28,
                      color: Color.fromRGBO(126, 163, 212, 1),
                    ),
                  ),
                  buildDate(),
                  buildBalanceLevel(),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: SfCircularChart(
                borderColor: Colors.white,
                borderWidth: 4,
                backgroundColor: Color.fromRGBO(179, 203, 236, 1),
                legend: Legend(
                  isVisible: true,
                ),
                tooltipBehavior: _tooltipBehavior,
                series: <CircularSeries>[
                  DoughnutSeries<TodoWeeklyData, String>(
                    dataSource: _chartData,
                    xValueMapper: (TodoWeeklyData data, _) => data.category,
                    yValueMapper: (TodoWeeklyData data, _) =>
                        double.parse(data.duration.toStringAsFixed(2)),
                    dataLabelMapper: (TodoWeeklyData data, _) => data.label,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                    ),
                    enableTooltip: true,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Expanded(
              flex: 4,
              child: PetQuoteWidget(
                balanceLevel: _balanceLevel,
                context: context,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDate() {
    DateTime now = DateTime.now();
    DateTime startDate = now.subtract(Duration(days: now.weekday - 1));
    DateTime endDate = now.add(Duration(days: 7 - now.weekday));
    return Text(
      "MON ---- SUN\n" +
          '${startDate.day} ${Utils.toMonthString(startDate.month)}' +
          ' ---- ${endDate.day} ${Utils.toMonthString(endDate.month)}',
      textAlign: TextAlign.center,
      style: GoogleFonts.boogaloo(
        fontSize: 22,
        color: Color.fromRGBO(126, 163, 212, 1),
      ),
    );
  }

  Widget buildBalanceLevel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
        border: Border.all(
          color: Color.fromRGBO(179, 203, 236, 1),
          width: 3.0,
        ),
      ),
      child: TextButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'BALANCE LEVEL: ${_balanceLevel.toStringAsFixed(2)}%    ',
              textAlign: TextAlign.center,
              style: GoogleFonts.boogaloo(
                fontSize: 22,
                color: Color.fromRGBO(126, 163, 212, 1),
              ),
            ),
            Icon(
              Icons.info_rounded,
              color: Color.fromRGBO(126, 163, 212, 1),
            ),
          ],
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Balance level shows how close you are to your desired work life balance (The goal you set in goal page)\n',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.boogaloo(
                        fontSize: 18,
                        color: Color.fromRGBO(126, 163, 212, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '1. Dashboard only shows progress (completed todos\' duration) in current week.\n\n2. To increase the balance level, the duration for a category must be within a difference of 35% with that of goal of same category. (To prevent overwork/too little work)',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.boogaloo(
                        fontSize: 18,
                        color: Color.fromRGBO(126, 163, 212, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 30);
    path.lineTo(size.height, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
