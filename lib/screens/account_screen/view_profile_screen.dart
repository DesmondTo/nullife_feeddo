import 'package:nullife_feeddo/models/user_profile.dart';
import 'package:nullife_feeddo/providers/email_signin_provider.dart';
import 'package:nullife_feeddo/providers/google_signin_provider.dart';
import 'package:nullife_feeddo/providers/userProfile_provider.dart';
import 'package:nullife_feeddo/screens/account_screen/edit_profile_screen.dart';
import 'package:nullife_feeddo/user_firebase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Container(
      child: StreamBuilder<List<UserProfile>>(
          stream: UserFirebaseApi.readUsersByUID(currentUser!.uid),
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

                  return SafeArea(
                    child: Scaffold(
                      body: Stack(
                        alignment: Alignment.center,
                        children: [
                          Flex(
                            direction: Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 8.0,
                                        color: Color.fromRGBO(236, 177, 134, 1),
                                      ),
                                    ),
                                    color: Color.fromRGBO(251, 237, 215, 1),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  child: Image.asset(
                                    'assets/images/account_screen_lowerbackground.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: buildProfileImage(user!),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    buildUserName(user),
                                    buildEmail(user),
                                    buildEditButton(user),
                                    buildLogOutButton(),
                                  ],
                                ),
                              ),
                            ],
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

  Widget buildProfileImage(UserProfile user) {
    return Container(
      margin: EdgeInsets.all(0.0),
      width: MediaQuery.of(context).size.width / 1.35,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xff000000),
        image: new DecorationImage(image: NetworkImage(user.userPhotoURL)),
        border: new Border.all(
          color: Color.fromRGBO(236, 177, 134, 1),
          width: 7.0,
        ),
      ),
    );
  }

  Widget buildUserName(UserProfile user) => Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.all(8),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Text(
                'Username',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromRGBO(236, 177, 134, 1),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(236, 177, 134, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    user.userName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildEmail(UserProfile user) => Container(
        width: double.infinity,
        margin: EdgeInsets.all(8),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Text(
                'Email',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromRGBO(236, 177, 134, 1),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(236, 177, 134, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: SingleChildScrollView(
                    child: Text(
                      user.email,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildEditButton(UserProfile user) => RawMaterialButton(
        fillColor: Color.fromRGBO(255, 248, 232, 1),
        splashColor: Colors.orangeAccent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Profile',
              style: TextStyle(color: Color.fromRGBO(236, 177, 134, 1)),
            )
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProfileEdittingScreen(userProfile: user)));
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side:
                BorderSide(width: 3, color: Color.fromRGBO(236, 177, 134, 1))),
      );

  Widget buildLogOutButton() => RawMaterialButton(
        fillColor: Color.fromRGBO(255, 248, 232, 1),
        splashColor: Colors.orangeAccent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Log Out',
              style: TextStyle(color: Color.fromRGBO(236, 177, 134, 1)),
            )
          ],
        ),
        onPressed: () {
          if (FirebaseAuth
                  .instance.currentUser!.providerData.first.providerId ==
              'google.com') {
            final googleProvider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            googleProvider.logout(context);
          } else {
            final emailProvider =
                Provider.of<EmailSignInProvider>(context, listen: false);
            emailProvider.logout(context);
          }
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side:
                BorderSide(width: 3, color: Color.fromRGBO(236, 177, 134, 1))),
      );
}
