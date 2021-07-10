import 'package:nullife_feeddo/providers/todo_provider.dart';
import 'package:nullife_feeddo/widgets/todos_widget_folder/todo_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../utils.dart';

class CategoryButton extends StatelessWidget {
  final String category;
  final Color buttonColor;

  CategoryButton({
    Key? key,
    required this.category,
    required this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    double completedPercentage =
        provider.completedPercentageByCategory(category);

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TodoListWidget(category: this.category))),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 6.0),
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            Expanded(
              child: Text(
                '$category',
                style: GoogleFonts.boogaloo(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  color: Colors.white,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              flex: 2,
              child: CircularPercentIndicator(
                backgroundColor: Colors.transparent,
                progressColor: Utils.toProgressColor(category: category),
                radius: MediaQuery.of(context).size.height * 0.1,
                lineWidth: 7.5,
                percent: completedPercentage / 100,
                center: Text(
                  'Completed\n${completedPercentage.toStringAsFixed(1)}',
                  style: GoogleFonts.boogaloo(
                    fontSize: MediaQuery.of(context).size.height * 0.015,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: buttonColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 5.0,
            ),
          ],
        ),
      ),
    );
  }
}