import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nullife_feeddo/models/goal_model.dart';
import 'package:nullife_feeddo/models/todo_weekly_data.dart';
import 'package:nullife_feeddo/providers/todo_provider.dart';
import 'package:nullife_feeddo/utils.dart';
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
              : ((match.hour + match.minute / 60) <= data.duration &&
                      ((data.duration - (match.hour + match.minute / 60)) /
                              data.duration) <
                          0.1
                  ? 1
                  : 0));
    });
    _balanceLevel = _numOfHittedTarget * 100 / _goals.length;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(
        text: buildTitle(),
        textStyle: GoogleFonts.boogaloo(
          color: Color(0xFF7EA3D4),
          fontSize: 18,
        ),
        alignment: ChartAlignment.center,
      ),
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.scroll,
      ),
      tooltipBehavior: _tooltipBehavior,
      series: <CircularSeries>[
        DoughnutSeries<TodoWeeklyData, String>(
          dataSource: _chartData,
          xValueMapper: (TodoWeeklyData data, _) => data.category,
          yValueMapper: (TodoWeeklyData data, _) =>
              double.parse(data.duration.toStringAsFixed(2)),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
          ),
          enableTooltip: true,
        ),
      ],
    );
  }

  String buildTitle() {
    DateTime now = DateTime.now();
    DateTime startDate = now.subtract(Duration(days: now.weekday - 1));
    DateTime endDate = now.add(Duration(days: 7 - now.weekday));
    return 'Weekly Dashboard\n' +
        'MON ---- SUN\n${startDate.day} ${Utils.toMonthString(startDate.month)}' +
        ' ---- ${endDate.day} ${Utils.toMonthString(endDate.month)}\n' +
        'Balance level: ${_balanceLevel.toStringAsFixed(2)}%';
  }
}
