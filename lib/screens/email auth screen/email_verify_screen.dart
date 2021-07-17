import 'dart:async';

import 'package:nullife_feeddo/widgets/login/login_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({
    Key? key,
  }) : super(key: key);

  @override
  _EmailVerifyScreenState createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  final auth = FirebaseAuth.instance;
  late Timer _timer;
  int _countDown = 300;

  User? user;

  @override
  void initState() {
    user = auth.currentUser;
    user!.sendEmailVerification();
    const oneSec = const Duration(seconds: 1);

    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (_countDown == 0) {
          setState(() {
            _timer.cancel();
          });
          if (!user!.emailVerified) user!.delete();
          Navigator.pop(context);
        } else {
          setState(() {
            _countDown--;
          });
          checkEmailVerified();
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!auth.currentUser!.emailVerified) {
          auth.currentUser!.delete();
        }
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFFCE9C8),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'An email has been sent to ',
                    style: GoogleFonts.boogaloo(
                      color: Color.fromRGBO(236, 177, 134, 1),
                      fontWeight: FontWeight.normal,
                      fontSize: 30,
                    ),
                  ),
                  TextSpan(
                    text: user?.email ?? 'Unknown Email',
                    style: GoogleFonts.boogaloo(
                      color: Color.fromRGBO(236, 177, 134, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  TextSpan(
                    text: ', please verify within $_countDown seconds!',
                    style: GoogleFonts.boogaloo(
                      color: Color.fromRGBO(236, 177, 134, 1),
                      fontWeight: FontWeight.normal,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/verify_screen_dog.png',
                ),
                Image.asset(
                  'assets/images/verify_screen_footprint.png',
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user!.reload();
    if (user!.emailVerified) {
      _timer.cancel();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LogInWidget()));
    }
  }
}
