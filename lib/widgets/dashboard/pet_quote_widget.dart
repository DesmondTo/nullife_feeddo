import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nullife_feeddo/providers/userProfile_provider.dart';
import 'package:provider/provider.dart';

class PetQuoteWidget extends StatefulWidget {
  final double balanceLevel;
  final BuildContext context;

  const PetQuoteWidget({
    Key? key,
    required this.balanceLevel,
    required this.context,
  }) : super(key: key);

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
  late double _balanceLevel;

  @override
  void initState() {
    super.initState();
    _balanceLevel = widget.balanceLevel;
  }

  @override
  Widget build(BuildContext context) {
    final _petID =
        Provider.of<UserProfileProvider>(context).getCurrentUser()!.petID;

    return Stack(
      children: [
        Flex(
          direction: Axis.horizontal,
          children: [
            _petID == 0
                ? Image.asset(
                    _balanceLevel >= 66.70
                        ? "assets/pet/plant_happy.gif"
                        : _balanceLevel >= 33.33 && _balanceLevel < 66.70
                            ? "assets/pet/plant_meh.gif"
                            : "assets/pet/plant_sad.gif",
                    width: MediaQuery.of(context).size.width / 2,
                    fit: BoxFit.cover,
                  )
                : _petID == 1 && _balanceLevel >= 33.33
                    ? Image.asset(
                        _balanceLevel >= 66.70
                            ? "assets/pet/water_happy.gif"
                            : "assets/pet/water_meh.gif",
                        width: MediaQuery.of(context).size.width / 1.7,
                        fit: BoxFit.cover,
                      )
                    : _petID == 1 && _balanceLevel < 33.33
                        ? Image.asset(
                            "assets/pet/water_sad.gif",
                            width: MediaQuery.of(context).size.width / 2,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            _balanceLevel >= 66.70
                                ? "assets/pet/sun_happy.gif"
                                : _balanceLevel >= 33.33 &&
                                        _balanceLevel < 66.70
                                    ? "assets/pet/sun_meh.gif"
                                    : "assets/pet/sun_sad.gif",
                            width: MediaQuery.of(context).size.width / 2,
                            fit: BoxFit.cover,
                          ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 0, right: 30),
                  child: Container(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DefaultTextStyle(
                            style: GoogleFonts.boogaloo(
                              fontSize: 20,
                              color: _petID == 0
                                  ? Color.fromRGBO(74, 97, 87, 1)
                                  : _petID == 1
                                      ? Color.fromRGBO(20, 60, 113, 1)
                                      : Color.fromRGBO(195, 92, 39, 1),
                              fontWeight: FontWeight.bold,
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
          ],
        ),
      ],
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
