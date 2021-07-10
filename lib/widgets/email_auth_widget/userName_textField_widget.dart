import 'package:nullife_feeddo/providers/email_signin_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserNameTextField extends StatelessWidget {
  const UserNameTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(context);
    final size = MediaQuery.of(context).size;
    return TextFormField(
      key: ValueKey('username'),
      autocorrect: true,
      textCapitalization: TextCapitalization.words,
      enableSuggestions: false,
      validator: (value) {
        if (value!.isEmpty || value.length < 4 || value.contains(' ')) {
          return 'Please enter at least 4 characters without space';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.deepOrange.shade200,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.deepOrange.shade200,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FaIcon(
            FontAwesomeIcons.userAlt,
            color: Color(0xffF8CCB1),
          ),
        ),
        labelStyle: GoogleFonts.boogaloo(
          fontWeight: FontWeight.bold,
          color: Colors.deepOrange.shade200,
          fontSize: size.height * 0.035,
        ),
        labelText: 'Username',
      ),
      style: GoogleFonts.boogaloo(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: size.height * 0.035,
      ),
      onSaved: (username) {
        provider.userName = username!;
      },
    );
  }
}
