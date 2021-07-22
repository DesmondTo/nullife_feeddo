import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nullife_feeddo/models/goal_model.dart';
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
    _goals = widget.goals;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCircularChart(
        title: ChartTitle(
          text: 'This is how ur balanced life looks like in a week!',
          textStyle: GoogleFonts.boogaloo(
            color: Color(0xFF7EA3D4),
            fontSize: 18,
          ),
          alignment: ChartAlignment.center,
        ),
        legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        tooltipBehavior: _tooltipBehavior,
        series: <CircularSeries>[
          DoughnutSeries<Goal, String>(
            dataSource: _goals,
            xValueMapper: (Goal data, _) => data.category,
            yValueMapper: (Goal data, _) =>
                double.parse((data.hour + data.minute / 60).toStringAsFixed(2)),
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
            ),
            enableTooltip: true,
          ),
        ],
      ),
    );
  }
}
