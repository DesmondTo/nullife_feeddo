import 'dart:ui';

import 'package:nullife_feeddo/screens/email%20auth%20screen/email_auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailSignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.65,
      height: size.height * 0.1,
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Sign Up With Email",
              textAlign: TextAlign.center,
              style: GoogleFonts.boogaloo(
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.03,
                color: Colors.black,
              ),
            ),
            Image.asset(
              'assets/icons/gmail_colorful_icon.png',
              width: size.width * 0.1,
            ),
          ],
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Color(0xff91C9C0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
              color: Colors.white,
              width: 5,
            ),
          ),
          textStyle: TextStyle(
            color: Colors.black,
          ),
        ),
        onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => EmailAuthScreen()),
        ),
      ),
    );
  }
}
