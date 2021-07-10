import 'package:nullife_feeddo/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryHeader extends StatelessWidget {
  const CategoryHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Material(
            elevation: 10,
            shadowColor: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color(0xffECD9BB),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 5.0,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            Utils.toWeekDayString(
                              DateTime.now().weekday,
                            ),
                            style: GoogleFonts.boogaloo(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFCEB59F),
                              fontSize: 100,
                            ),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              DateTime.now().day.toString() + ' ',
                              style: GoogleFonts.boogaloo(
                                color: Color(0xFFCEB59F),
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              Utils.toMonthString(DateTime.now().month),
                              style: GoogleFonts.boogaloo(
                                color: Color(0xFFCEB59F),
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(
                    "WHAT WILL YOU FEED YOUR PET TODAY?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.boogaloo(
                      fontSize: MediaQuery.of(context).size.width * 0.075,
                      color: Color(0xFF865946),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
