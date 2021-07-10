import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EntryPageBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/arrow_banner.png',
                  width: size.width * 0.9,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 10),
            child: Text(
              'ADOPT ME, \n    ADOPT A HEALTHY LIFESTYLE',
              style: GoogleFonts.boogaloo(
                color: Color(0xff91C9C0),
                fontSize: size.width * 0.065,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
