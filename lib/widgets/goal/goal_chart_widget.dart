import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nullife_feeddo/models/goal_model.dart';
import 'package:nullife_feeddo/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GoalChart extends StatefulWidget {
  final List<Goal> goals;

  const GoalChart({
    Key? key,
    required this.goals,
  }) : super(key: key);

  @override
  _GoalChartState createState() => _GoalChartState();
}

class _GoalChartState extends State<GoalChart> {
  late TooltipBehavior _tooltipBehavior;
  late List<Goal> _goals;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _goals = widget.goals
        .map((goal) => goal.category.length > 15
            ? Goal(
                category: goal.category.substring(0, 14),
                createdTime: goal.createdTime,
                hour: goal.hour,
                minute: goal.minute,
                id: goal.id,
                userId: goal.userId,
              )
            : goal)
        .toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeader(),
        Container(
          padding: EdgeInsets.only(top: 30),
          width: MediaQuery.of(context).size.width / 1.05,
          height: MediaQuery.of(context).size.height / 2.7,
          child: SfCircularChart(
            borderColor: Colors.white,
            borderWidth: 4,
            backgroundColor: Color.fromRGBO(193, 197, 175, 1),
            legend: Legend(
              isVisible: true,
            ),
            tooltipBehavior: _tooltipBehavior,
            series: <CircularSeries>[
              DoughnutSeries<Goal, String>(
                dataSource: _goals,
                xValueMapper: (Goal data, _) => data.category,
                yValueMapper: (Goal data, _) => double.parse(
                    (data.hour + data.minute / 60).toStringAsFixed(2)),
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                ),
                enableTooltip: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(152, 159, 122, 1),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border:
              Border.all(color: Color.fromRGBO(234, 236, 228, 1), width: 3)),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Text(
            "YOUR WEEKLY SET GOAL",
            style: GoogleFonts.boogaloo(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }

  String buildTitle() {
    DateTime now = DateTime.now();
    DateTime startDate = now.subtract(Duration(days: now.weekday - 1));
    DateTime endDate = now.add(Duration(days: 7 - now.weekday));
    return 'Your desired work-life balance for this week\n' +
        'MON ---- SUN\n${startDate.day} ${Utils.toMonthString(startDate.month)}' +
        ' ---- ${endDate.day} ${Utils.toMonthString(endDate.month)}\n';
  }
}
