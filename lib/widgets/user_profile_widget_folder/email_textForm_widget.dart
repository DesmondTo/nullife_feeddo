import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailTextFormWidget extends StatelessWidget {
  final TextEditingController emailController;

  EmailTextFormWidget({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        style: GoogleFonts.boogaloo(
          fontSize: 24,
        ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'Change email',
          contentPadding: EdgeInsets.only(left: 50, right: 50),
          hintStyle: TextStyle(color: Color.fromRGBO(29, 20, 13, 1)),
          filled: true,
          fillColor: Color.fromRGBO(255, 248, 232, 1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide:
                BorderSide(color: Color.fromRGBO(29, 20, 13, 1), width: 3),
          ),
        ),
        onFieldSubmitted: (_) {},
        validator: (email) =>
            email != null && email.isEmpty ? 'Email cannot be empty' : null,
        controller: emailController,
      ),
    );
  }
}
