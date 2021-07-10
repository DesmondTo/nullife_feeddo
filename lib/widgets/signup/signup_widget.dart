import 'package:nullife_feeddo/models/user_profile.dart';
import 'package:nullife_feeddo/providers/google_signin_provider.dart';
import 'package:nullife_feeddo/screens/loading_screen.dart';
import 'package:nullife_feeddo/user_firebase_api.dart';
import 'package:nullife_feeddo/widgets/login/login_widget.dart';
import 'package:nullife_feeddo/widgets/signup/email_signup_button_widget.dart';
import 'package:nullife_feeddo/widgets/signup/google_signup_button_widget.dart';
import 'package:nullife_feeddo/widgets/signup/signup_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xffB7E7DF),
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot1) {
            if (googleSignInProvider.isSigningIn) {
              return LoadingScreen();
            } else if (snapshot1.hasData) {
              User? user = FirebaseAuth.instance.currentUser;
              return StreamBuilder<List<UserProfile>>(
                stream: UserFirebaseApi.readUsersByUID(user!.uid),
                builder: (context, snapshot2) {
                  switch (snapshot2.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      if (snapshot2.hasError) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Something went wrong, please try again'),
                            Text('The error is: ' + snapshot2.error.toString()),
                          ],
                        );
                      } else {
                        return LogInWidget();
                      }
                  }
                },
              );
            } else {
              return SignUpBackground(
                child: SingleChildScrollView(
                  child: buildSignUp(context, size),
                ),
              );
            }
          }),
    );
  }
}

Widget buildSignUp(BuildContext context, Size screenSize) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'SIGN UP',
          style: GoogleFonts.boogaloo(
            fontSize: screenSize.height * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: screenSize.height * 0.05,
        ),
        GoogleSignUpButton(),
        SizedBox(
          height: screenSize.height * 0.05,
        ),
        EmailSignUpButton(),
        SizedBox(
          height: screenSize.height * 0.05,
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LogInWidget()));
          },
          child: Text(
            'Had an account? Log In',
            textAlign: TextAlign.center,
            style: GoogleFonts.boogaloo(
              fontSize: screenSize.width * 0.065,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
