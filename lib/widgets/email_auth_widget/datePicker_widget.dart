import 'package:nullife_feeddo/providers/email_signin_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(context);
    final dateOfBirth = provider.dateOfBirth;
    final size = MediaQuery.of(context).size;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(
                color: Colors.deepOrange.shade200,
                width: 3,
              ),
            ),
            leading: FaIcon(
              FontAwesomeIcons.calendarCheck,
              color: Color(0xffF8CCB1),
              size: size.width * 0.08,
            ),
            title: Text(
              '${dateOfBirth.year} - ${dateOfBirth.month}- ${dateOfBirth.day}',
              style: GoogleFonts.boogaloo(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange.shade200,
                fontSize: size.height * 0.035,
              ),
            ),
            trailing: Icon(Icons.keyboard_arrow_down),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                firstDate: DateTime(DateTime.now().year - 80),
                lastDate: DateTime(DateTime.now().year + 1),
                initialDate: dateOfBirth,
              );

              if (date != null) {
                provider.dateOfBirth = date;
              }
            },
          ),
        ],
      ),
    );
  }
}
