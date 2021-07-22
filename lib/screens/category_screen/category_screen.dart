import 'package:firebase_auth/firebase_auth.dart';
import 'package:nullife_feeddo/models/user_profile.dart';
import 'package:nullife_feeddo/providers/userProfile_provider.dart';
import 'package:nullife_feeddo/user_firebase_api.dart';
import 'package:nullife_feeddo/widgets/category_widget/category_button.dart';
import 'package:nullife_feeddo/widgets/category_widget/category_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<List<UserProfile>>(
          stream: UserFirebaseApi.readUsersByUID(
              FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Something went wrong, please try again!',
                    ),
                  );
                } else {
                  final List<UserProfile>? users = snapshot.data;

                  final provider = Provider.of<UserProfileProvider>(context);
                  final user = provider.getCurrentUser();

                  provider.setUsers(users!);

                  List<CategoryButton> categoryButtonList =
                      user!.categoryFieldList.asMap().entries.map((category) {
                    int idx = category.key;
                    String val = category.value;
                    return CategoryButton(
                        userProfile: user,
                        index: idx,
                        category: val.substring(0, val.indexOf(":")).trim(),
                        buttonColor: Color(int.parse(
                            val.substring(val.indexOf(":") + 1).trim())));
                  }).toList();

                  return SingleChildScrollView(
                    child: Center(
                      heightFactor: 1.2,
                      child: Column(
                        children: [
                          CategoryHeader(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.55,
                            child: GridView.count(
                              primary: false,
                              padding: const EdgeInsets.all(20),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 2,
                              children: categoryButtonList,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            }
          }),
    );
  }
}
