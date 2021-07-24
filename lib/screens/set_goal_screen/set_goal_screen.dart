import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nullife_feeddo/Goal_firebase_api.dart';
import 'package:nullife_feeddo/models/goal_model.dart';
import 'package:nullife_feeddo/providers/goal_provider.dart';
import 'package:nullife_feeddo/providers/userProfile_provider.dart';
import 'package:nullife_feeddo/screens/set_goal_screen/edit_goal_screen.dart';
import 'package:nullife_feeddo/widgets/goal/goal_chart_widget.dart';
import 'package:nullife_feeddo/widgets/goal/goal_widget.dart';
import 'package:provider/provider.dart';

class SetGoalScreen extends StatefulWidget {
  const SetGoalScreen({Key? key}) : super(key: key);

  @override
  _SetGoalScreenState createState() => _SetGoalScreenState();
}

class _SetGoalScreenState extends State<SetGoalScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    final user = provider.getCurrentUser();

    return SafeArea(
      child: StreamBuilder<List<Goal>>(
        stream: GoalFirebaseApi.readGoals(currentUser!.uid),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text('Something went wrong, please try again later' +
                      '\n${snapshot.error.toString()}'),
                );
              } else {
                final List<Goal>? goals = snapshot.data;

                final provider = Provider.of<GoalProvider>(context);
                List<Goal> _goals = provider.goals;
                List<String> existingCategory =
                    _goals.map((goal) => goal.category).toList();

                provider.setGoals(goals!);
                return Scaffold(
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      final originalList =
                          user!.categoryFieldList.map((categoryString) {
                        return categoryString
                            .substring(0, categoryString.indexOf(":"))
                            .trim();
                      }).toList();
                      originalList.removeWhere(
                          (category) => existingCategory.contains(category));

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoalEditingScreen(
                            categoryList: originalList,
                          ),
                        ),
                      );
                    },
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: GoalChart(goals: goals),
                      ),
                      Expanded(
                        flex: 2,
                        child: _goals.isEmpty
                            ? Center(
                                child: Text(
                                  'No goals added',
                                ),
                              )
                            : ListView.separated(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.all(16),
                                separatorBuilder: (context, index) =>
                                    Container(height: 8),
                                itemCount: _goals.length,
                                itemBuilder: (context, index) {
                                  return GoalWidget(
                                    goal: _goals[index],
                                    existingCategory: existingCategory,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
