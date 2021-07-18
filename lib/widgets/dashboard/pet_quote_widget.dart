import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PetQuoteWidget extends StatefulWidget {
  const PetQuoteWidget({Key? key}) : super(key: key);

  @override
  _PetQuoteWidgetState createState() => _PetQuoteWidgetState();
}

class _PetQuoteWidgetState extends State<PetQuoteWidget> {
  final List<String> quote = const [
    'Did you know when you dont sleep, you tend to eat more especially junk food?',
    'Exercise not just a few times a week, but every day.',
    'By moving your body in some way for 30 minutes a day will lower your risk of disease, create higher bone density and potentially increase your life span',
    'Eat the rainbow. Pick brightly-colored foods in the produce aisle. These are high in antioxidants and make a more appealing plate.',
    'Sleep for at least 7 hours a day!'
  ];
  var currentHour = DateTime.now().hour;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 0.0),
                child: Container(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/dashboard_speechbubble.svg',
                        fit: BoxFit.contain,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DefaultTextStyle(
                          style: GoogleFonts.roboto(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(236, 177, 134, 1),
                          ),
                          textAlign: TextAlign.end,
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                displayQuote(),
                                speed: const Duration(milliseconds: 200),
                              ),
                            ],
                            repeatForever: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            flex: 1,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 25.0),
              child: Image.asset(
                "assets/images/dashboard_pet.gif",
                fit: BoxFit.fitWidth,
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  String displayQuote() {
    if (currentHour >= 5 && currentHour <= 11) {
      return quote[0];
    } else if (currentHour >= 12 && currentHour <= 16) {
      return quote[1];
    } else if (currentHour >= 17 && currentHour <= 7) {
      return quote[2];
    } else if (currentHour >= 8 && currentHour <= 11) {
      return quote[3];
    } else {
      return quote[4];
    }
  }
}
