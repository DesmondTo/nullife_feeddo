import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  var quote = [
    'Did you know when you dont sleep, you tend to eat more especially junk food?',
    'Exercise not just a few times a week, but every day.',
    'By moving your body in some way for 30 minutes a day will lower your risk of disease, create higher bone density and potentially increase your life span',
    'Eat the rainbow. Pick brightly-colored foods in the produce aisle. These are high in antioxidants and make a more appealing plate.',
    'sleep for at least 7 hours a day!'
  ];

  var currentHour = DateTime.now().hour;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(10),
          child: Stack(
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/dashboard.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  "assets/images/pet.gif",
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.25,
                left: 0,
                child: SvgPicture.asset(
                  'assets/images/speechbubble.svg',
                  fit: BoxFit.fitWidth,
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.3,
                left: 0,
                child: Container(
                  height: 90,
                  width: 200,
                  padding: EdgeInsets.all(13),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(236, 177, 134, 1),
                      ),
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
                ),
              ),
            ],
          ),
        ),
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
