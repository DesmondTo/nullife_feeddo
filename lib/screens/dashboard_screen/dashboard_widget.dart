import 'package:flutter/material.dart';
import 'package:nullife_feeddo/widgets/dashboard/dashboard_chart_widget.dart';
import 'package:nullife_feeddo/widgets/dashboard/pet_quote_widget.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 1,
              child: DashBoardChart(),
            ),
            PetQuoteWidget(),
          ],
        ),
      ),
    );
  }
}
