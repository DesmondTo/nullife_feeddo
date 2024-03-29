import 'package:nullife_feeddo/models/todo_model.dart';
import 'package:nullife_feeddo/providers/todo_provider.dart';
import 'package:nullife_feeddo/screens/account_screen/view_profile_screen.dart';
import 'package:nullife_feeddo/screens/dashboard_screen/dashboard_widget.dart';
import 'package:nullife_feeddo/screens/schedule_screen/schedule_widget.dart';
import 'package:nullife_feeddo/screens/set_goal_screen/set_goal_screen.dart';
import 'package:nullife_feeddo/todo_firebase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'category_screen/category_screen.dart';

class HomeScreen extends StatefulWidget {
  final int? defaultIndex;

  HomeScreen({
    this.defaultIndex,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.defaultIndex ?? 2;
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    // Store the current user in this variable.
    final tabs = [
      DashboardWidget(),
      SetGoalScreen(),
      CategoryScreen(),
      ScheduleWidget(),
      UserProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF9F1E4),
      bottomNavigationBar: buildBottomNavBar(),
      body: StreamBuilder<List<Todo>>(
        stream: TodoFirebaseApi.readTodos(currentUser!.uid),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                print('The error is: ' + snapshot.error.toString());
                return buildText(
                    'Something went wrong, please try again later' +
                        '\n${snapshot.error.toString()}');
              } else {
                final List<Todo>? todos = snapshot.data;

                final provider = Provider.of<TodoProvider>(context);
                provider.setTodos(todos!);

                return tabs[selectedIndex];
              }
          }
        },
      ),
    );
  }

  ConvexAppBar buildBottomNavBar() => ConvexAppBar(
        initialActiveIndex: widget.defaultIndex ?? 2,
        elevation: 0,
        backgroundColor: Color(0xFF322A37),
        color: Colors.white,
        activeColor: selectedIndex == 0
            ? Color(0xFFDFC03D)
            : selectedIndex == 1
                ? Color(0xFF4FAEDF)
                : selectedIndex == 2
                    ? Color(0xFF872BE1)
                    : selectedIndex == 3
                        ? Color(0xFFD62F80)
                        : Color(0xFFA8DC99),
        style: TabStyle.react,
        items: [
          TabItem(
            icon: SvgPicture.asset(
              'assets/icons/dashboard.svg',
              color: Color(0xFFDFC03D),
            ),
            title: 'Dashboard',
          ),
          TabItem(
            icon: SvgPicture.asset(
              'assets/icons/goal.svg',
              color: Color(0xFF4FAEDF),
            ),
            title: 'Goal',
          ),
          TabItem(
            icon: SvgPicture.asset(
              'assets/icons/category.svg',
              color: Color(0xFF872BE1),
            ),
            title: 'Category',
          ),
          TabItem(
            icon: SvgPicture.asset(
              "assets/icons/schedule.svg",
              color: Color(0xFFD62F80),
            ),
            title: 'Schedule',
          ),
          TabItem(
            icon: SvgPicture.asset(
              'assets/icons/user.svg',
              color: Color(0xFFA8DC99),
            ),
            title: 'Account',
          ),
        ],
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
      );
}

Widget buildText(String text) => Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
