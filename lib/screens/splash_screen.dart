import 'dart:async';

import 'package:nullife_feeddo/screens/entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => EntryScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff91C9C0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(
              flex: 3,
            ),
            Image.asset(
              'assets/images/splash_screen.png',
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'FEED',
                  style: GoogleFonts.boogaloo(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
                TextSpan(
                  text: 'DO',
                  style: GoogleFonts.boogaloo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
              ]),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Feed with ',
                  style: GoogleFonts.boogaloo(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                TextSpan(
                  text: 'to-dos',
                  style: GoogleFonts.boogaloo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ]),
            ),
            Spacer(),
            Text(
              'Nullife',
              style: GoogleFonts.boogaloo(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            )
          ],
        ),
      ),
    );
  }
}
