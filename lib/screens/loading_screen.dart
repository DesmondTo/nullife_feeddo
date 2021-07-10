import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffFFDED9),
      body: buildLoading(context, size),
    );
  }

  Widget buildLoading(BuildContext context, Size screenSize) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/wiener_dog.gif',
                  width: screenSize.width * 0.9,
                  height: screenSize.height * 0.5,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  child: SpinKitThreeBounce(
                    color: Colors.black,
                  ),
                  height: 8,
                  width: screenSize.width * 0.8,
                ),
                Text(
                  'Loading...',
                  style: GoogleFonts.boogaloo(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          )
        ],
      );
}
