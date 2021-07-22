import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nullife_feeddo/goal_firebase_api.dart';
import 'package:nullife_feeddo/models/goal_model.dart';
import 'package:nullife_feeddo/models/user_profile.dart';
import 'package:nullife_feeddo/providers/goal_provider.dart';
import 'package:nullife_feeddo/providers/userProfile_provider.dart';
import 'package:nullife_feeddo/widgets/dashboard/dashboard_chart_widget.dart';
import 'package:nullife_feeddo/widgets/dashboard/pet_quote_widget.dart';
import 'package:provider/provider.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final UserProfileProvider provider =
        Provider.of<UserProfileProvider>(context, listen: false);
    final UserProfile? user = provider.getCurrentUser();
    final List<String> categoryList = user!.categoryFieldList
        .map((categoryString) =>
            categoryString.substring(0, categoryString.indexOf(":")).trim())
        .toList();

    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<List<Goal>>(
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
                  final List<Goal>? _goals = snapshot.data;

                  final provider = Provider.of<GoalProvider>(context);
                  provider.setGoals(_goals!);

                  return Column(
                    children: [
                      DashBoardChart(
                        categoryList: categoryList,
                        goals: _goals,
                      ),
                      PetQuoteWidget(),
                    ],
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
