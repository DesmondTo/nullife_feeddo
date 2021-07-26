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
    _goals = widget.goals
        .map((goal) => goal.category.length > 11
            ? Goal(
                category: goal.category.substring(0, 10) + '...',
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
            title: ChartTitle(
              text: 'in Hour',
              textStyle: GoogleFonts.boogaloo(
                color: Color.fromRGBO(152, 159, 122, 1),
                fontSize: 18,
              ),
              alignment: ChartAlignment.center,
            ),
            borderColor: Colors.white,
            borderWidth: 4,
            backgroundColor: Color.fromRGBO(193, 197, 175, 1),
            legend: Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.scroll,
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
            textAlign: TextAlign.center,
            style: GoogleFonts.boogaloo(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }
}
