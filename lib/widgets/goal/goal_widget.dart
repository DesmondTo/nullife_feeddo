import 'package:nullife_feeddo/models/goal_model.dart';
import 'package:nullife_feeddo/providers/goal_provider.dart';
import 'package:nullife_feeddo/providers/userProfile_provider.dart';
import 'package:nullife_feeddo/screens/set_goal_screen/edit_goal_screen.dart';
import 'package:nullife_feeddo/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class GoalWidget extends StatefulWidget {
  final Goal goal;
  final List<String> existingCategory;

  const GoalWidget({
    required this.existingCategory,
    required this.goal,
    Key? key,
  }) : super(key: key);

  @override
  _GoalWidgetState createState() => _GoalWidgetState();
}

class _GoalWidgetState extends State<GoalWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        key: Key(widget.goal.id),
        actions: [
          IconSlideAction(
            color: Colors.green,
            onTap: () => editGoal(context, widget.goal),
            caption: 'Edit',
            icon: Icons.edit,
          )
        ],
        secondaryActions: [
          IconSlideAction(
            color: Colors.red,
            caption: 'Delete',
            onTap: () => deleteGoal(context, widget.goal),
            icon: Icons.delete,
          )
        ],
        child: Container(
          margin: const EdgeInsets.only(bottom: 6.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xff5C6947),
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xff5C6947),
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 5.0,
              ),
            ],
          ),
          child: buildGoal(context),
        ),
      ),
    );
  }

  Widget buildGoal(BuildContext context) => GestureDetector(
        onTap: () => editGoal(context, widget.goal),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 24,
                  child: SingleChildScrollView(
                    child: Text(
                      widget.goal.category,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black, //Color(0xff5C6947),
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 20,
                ),
              ),
              Expanded(
                child: Text(
                  '${widget.goal.hour} hr${widget.goal.hour > 1 ? 's' : ''} ${widget.goal.minute} min${widget.goal.minute > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black, //Color(0xff5C6947),
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  void deleteGoal(BuildContext context, Goal goal) {
    final provider = Provider.of<GoalProvider>(context, listen: false);
    provider.removeGoal(goal);
    Utils.showSnackBar(context, 'Deleted!');

    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (BuildContext context) => HomeScreen(
    //               defaultIndex: 1,
    //             )));
  }

  void editGoal(BuildContext context, Goal goal) {
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    final user = provider.getCurrentUser();
    final originalList = user!.categoryFieldList.map((categoryString) {
      return categoryString.substring(0, categoryString.indexOf(":")).trim();
    }).toList();
    originalList
        .removeWhere((category) => widget.existingCategory.contains(category));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GoalEditingScreen(
          goal: goal,
          categoryList: originalList,
        ),
      ),
    );
  }
}
