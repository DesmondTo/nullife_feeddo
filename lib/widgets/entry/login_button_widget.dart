import 'package:nullife_feeddo/providers/email_signin_provider.dart';
import 'package:nullife_feeddo/widgets/login/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LogInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = Provider.of<EmailSignInProvider>(context);

    return SizedBox(
      width: size.width * 0.8,
      height: size.height * 0.08,
      child: ElevatedButton(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "Log In",
                textAlign: TextAlign.center,
                style: GoogleFonts.boogaloo(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Color(0xff91C9C0),
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
              color: Colors.white,
              width: 5,
            ),
          ),
        ),
        onPressed: () {
          provider.isLogin = true;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LogInWidget()),
          );
        },
      ),
    );
  }
}
