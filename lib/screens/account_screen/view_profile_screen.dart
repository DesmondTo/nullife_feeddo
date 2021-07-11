import 'package:google_fonts/google_fonts.dart';
import 'package:nullife_feeddo/models/pet_model.dart';
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
                      body: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: [
                            Flex(
                              direction: Axis.vertical,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 4,
                                  color: Color.fromRGBO(251, 237, 215, 1),
                                ),
                                const Divider(
                                  thickness: 8,
                                  color: Color.fromRGBO(236, 177, 134, 1),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(0),
                                    child: Image.asset(
                                      'assets/images/account_lowerbackground.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height / 12,
                              right: MediaQuery.of(context).size.width / 6,
                              child: Column(
                                children: [
                                  buildProfileImage(user!),
                                  Text(
                                    Pet.generatePetList()[user.petID].petName,
                                    style: GoogleFonts.boogaloo(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: MediaQuery.of(context).size.height / 2.7,
                              right: MediaQuery.of(context).size.width / 1.45,
                              child: Text(
                                'Username',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color.fromRGBO(236, 177, 134, 1),
                                ),
                              ),
                            ),
                            Positioned(
                              right: MediaQuery.of(context).size.width / 10,
                              bottom: MediaQuery.of(context).size.height / 2.85,
                              child: buildUserName(user),
                            ),
                            Positioned(
                              bottom: MediaQuery.of(context).size.height / 4,
                              right: MediaQuery.of(context).size.width / 1.3,
                              child: Text('Email',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color.fromRGBO(236, 177, 134, 1),
                                  )),
                            ),
                            Positioned(
                              right: MediaQuery.of(context).size.width / 10,
                              bottom: MediaQuery.of(context).size.height / 4.3,
                              child: buildEmail(user),
                            ),
                            Positioned(
                              right: MediaQuery.of(context).size.width / 2.7,
                              bottom: MediaQuery.of(context).size.height / 8,
                              child: buildEditButton(user),
                            ),
                            Positioned(
                              right: MediaQuery.of(context).size.width / 2.7,
                              bottom: MediaQuery.of(context).size.height / 20,
                              child: buildLogOutButton(),
                            )
                          ],
                        ),
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
      margin: EdgeInsets.all(20),
      width: 200,
      height: 200,
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
        width: 200,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(236, 177, 134, 1),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: FittedBox(
            fit: BoxFit.contain,
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
      );

  Widget buildEmail(UserProfile user) => Container(
        width: 200,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(236, 177, 134, 1),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: EdgeInsets.all(5),
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
          final googleProvider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          final emailProvider =
              Provider.of<EmailSignInProvider>(context, listen: false);
          if (FirebaseAuth.instance.currentUser!.displayName == '' ||
              FirebaseAuth.instance.currentUser!.displayName == null) {
            emailProvider.logout();
          } else {
            googleProvider.logout();
          }
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side:
                BorderSide(width: 3, color: Color.fromRGBO(236, 177, 134, 1))),
      );
}
