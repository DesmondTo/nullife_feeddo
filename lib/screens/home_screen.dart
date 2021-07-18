import 'package:nullife_feeddo/models/todo_model.dart';
import 'package:nullife_feeddo/providers/todo_provider.dart';
import 'package:nullife_feeddo/providers/userProfile_provider.dart';
import 'package:nullife_feeddo/screens/account_screen/view_profile_screen.dart';
import 'package:nullife_feeddo/screens/dashboard_screen/dashboard_widget.dart';
import 'package:nullife_feeddo/screens/schedule_screen/schedule_widget.dart';
import 'package:nullife_feeddo/todo_firebase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nullife_feeddo/widgets/category_widget/edit_category_widget.dart';
import 'package:provider/provider.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'category_screen/category_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Store the current user in this variable.
    final tabs = [
      CategoryScreen(),
      DashboardWidget(),
      ScheduleWidget(),
      UserProfileScreen(),
    ];
    User? currentUser = FirebaseAuth.instance.currentUser;
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    final user = provider.getCurrentUser();

    return Scaffold(
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) =>
                        EditCategoryDialog(userProfile: user!, index: null));
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ))
          : null,
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
        elevation: 0,
        backgroundColor: Color(0xFF374761),
        color: Colors.white,
        activeColor: Colors.white,
        style: TabStyle.react,
        items: [
          TabItem(
            icon: SvgPicture.asset(
              'assets/icons/category.svg',
            ),
            title: 'Category',
          ),
          TabItem(
            icon: SvgPicture.asset(
              'assets/icons/dashboard.svg',
            ),
            title: 'Dashboard',
          ),
          TabItem(
            icon: Image.asset(
              "assets/icons/schedule.png",
            ),
            title: 'Schedule',
          ),
          TabItem(
            icon: SvgPicture.asset(
              'assets/icons/user.svg',
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
