import 'package:nullife_feeddo/providers/email_signin_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(context);
    final size = MediaQuery.of(context).size;

    return TextFormField(
      key: ValueKey('password'),
      validator: (value) {
        if (value != null && (value.isEmpty || value.length < 7)) {
          return 'Password must be at least 7 characters long.';
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
            FontAwesomeIcons.lock,
            color: Color(0xffF8CCB1),
          ),
        ),
        labelStyle: GoogleFonts.boogaloo(
          fontWeight: FontWeight.bold,
          color: Colors.deepOrange.shade200,
          fontSize: size.height * 0.035,
        ),
        labelText: 'Password',
      ),
      style: GoogleFonts.boogaloo(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: size.height * 0.035,
      ),
      obscureText: true,
      onSaved: (password) => provider.userPassword = password!,
    );
  }
}
