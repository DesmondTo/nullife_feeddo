import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordTextFormWidget extends StatelessWidget {
  final TextEditingController passwordController;
  final String hintText;

  PasswordTextFormWidget({
    Key? key,
    required this.passwordController,
    required this.hintText,
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
        obscureText: true,
        decoration: InputDecoration(
          hintText: this.hintText,
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
        validator: (password) => password != null && password.isEmpty
            ? '${this.hintText} cannot be empty'
            : null,
        controller: passwordController,
      ),
    );
  }
}
