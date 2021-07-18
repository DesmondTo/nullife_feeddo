import 'package:flutter/material.dart';
import 'package:nullife_feeddo/models/todo_weekly_data.dart';
import 'package:nullife_feeddo/providers/todo_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashBoardChart extends StatefulWidget {
  const DashBoardChart({Key? key}) : super(key: key);

  @override
  _DashBoardChartState createState() => _DashBoardChartState();
}

class _DashBoardChartState extends State<DashBoardChart> {
  late List<TodoWeeklyData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  late TodoProvider _provider;

  @override
  void initState() {
    _provider = Provider.of<TodoProvider>(context, listen: false);
    _chartData = _provider.computeChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCircularChart(
        title: ChartTitle(
          text: 'Weekly Dashboard',
        ),
        legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        tooltipBehavior: _tooltipBehavior,
        series: <CircularSeries>[
          DoughnutSeries<TodoWeeklyData, String>(
            dataSource: _chartData,
            xValueMapper: (TodoWeeklyData data, _) => data.category,
            yValueMapper: (TodoWeeklyData data, _) =>
                double.parse(data.percentage.toStringAsFixed(2)),
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
