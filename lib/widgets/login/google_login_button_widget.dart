import 'package:nullife_feeddo/providers/google_signin_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// A button for the user to click to sign in with google.
class GoogleLogInButton extends StatelessWidget {
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
              "Log In With Google",
              textAlign: TextAlign.center,
              style: GoogleFonts.boogaloo(
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.03,
                color: Colors.black,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/icons/google_colorful_icon.png',
                height: size.height * 0.05,
              ),
            ),
          ],
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
              color: Color(0xff91C9C0),
              width: 5,
            ),
          ),
          textStyle: TextStyle(
            color: Colors.black,
          ),
        ),
        onPressed: () {
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          provider.login();
        },
      ),
    );
  }
}
