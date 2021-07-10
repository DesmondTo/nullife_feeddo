import 'dart:async';

import 'package:nullife_feeddo/models/user_profile.dart';
import 'package:nullife_feeddo/widgets/signup/signup_widget.dart';
import 'package:nullife_feeddo/widgets/user_profile_widget_folder/password_textForm_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordScreen extends StatefulWidget {
  final UserProfile userProfile;

  ChangePasswordScreen({required this.userProfile});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    passwordController.text = '';
    newPasswordController.text = '';
    confirmPasswordController.text = '';
  }

  @override
  void dispose() {
    passwordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: CloseButton(
            onPressed: () => Navigator.pop(context),
          ),
        ),
        extendBodyBehindAppBar: true,
        key: _scaffoldKey,
        backgroundColor: Color.fromRGBO(165, 145, 113, 1),
        body: Center(
          child: Card(
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      PasswordTextFormWidget(
                        passwordController: passwordController,
                        hintText: 'Current password',
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      PasswordTextFormWidget(
                        passwordController: newPasswordController,
                        hintText: 'New password',
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      PasswordTextFormWidget(
                        passwordController: confirmPasswordController,
                        hintText: 'Confirm password',
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(236, 177, 134, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        ),
                        onPressed: changePassword,
                        child: Text(
                          'Confirm',
                          style: GoogleFonts.boogaloo(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.075),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(
                color: Colors.white,
                width: 3,
              ),
            ),
            color: Colors.brown.shade500,
          ),
        ),
      ),
    );
  }

  Future changePassword() async {
    final isValid = _formKey.currentState!.validate();
    final originalProfile = widget.userProfile;

    if (confirmPasswordController.text != newPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Your new password does not match your confirm password!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      try {
        await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: originalProfile.email.toLowerCase(),
            password: passwordController.text,
          ),
        );

        FirebaseAuth.instance.currentUser!
            .updatePassword(newPasswordController.text)
            .whenComplete(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              content: Text('Password changed successfully'),
              backgroundColor: Colors.green.shade400,
            ),
          );
          Timer(Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignUpWidget()),
            );
          });
        });
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.code),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    }
  }
}
