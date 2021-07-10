import 'dart:async';

import 'package:nullife_feeddo/providers/email_signin_provider.dart';
import 'package:nullife_feeddo/screens/email%20auth%20screen/email_verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ActionButton extends StatelessWidget {
  final BuildContext pageContext;
  final GlobalKey<FormState> formKey;

  const ActionButton({
    Key? key,
    required this.pageContext,
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(pageContext);
    final size = MediaQuery.of(pageContext).size;

    if (provider.isLoading) {
      return CircularProgressIndicator();
    } else {
      return Column(
        children: [
          buildLoginButton(context),
          SizedBox(height: size.height * 0.01),
          buildSignupButton(),
        ],
      );
    }
  }

  Widget buildLoginButton(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(pageContext);
    final size = MediaQuery.of(pageContext).size;

    return SizedBox(
      width: size.width * 0.75,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Color(0xffF6A5A1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          side: BorderSide(
            color: Colors.white,
            width: 3,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            provider.isLogin ? 'Login' : 'Signup',
            style: GoogleFonts.boogaloo(
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.035,
              color: Colors.white,
            ),
          ),
        ),
        onPressed: () => submit(context),
      ),
    );
  }

  Widget buildSignupButton() {
    final provider = Provider.of<EmailSignInProvider>(pageContext);
    final size = MediaQuery.of(pageContext).size;

    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(
          color: Theme.of(pageContext).primaryColor,
        ),
      ),
      child: Column(
        children: [
          Text(
            provider.isLogin
                ? 'Haven’t register? '
                : 'Already have an account? ',
            style: GoogleFonts.boogaloo(
              fontSize: size.height * 0.025,
              fontWeight: FontWeight.normal,
              color: Color(0xffFFABA7),
            ),
          ),
          Text(
            provider.isLogin ? 'SIGN UP HERE' : 'LOG IN HERE',
            style: GoogleFonts.boogaloo(
              fontSize: size.height * 0.035,
              fontWeight: FontWeight.bold,
              color: Color(0xffF8868E),
            ),
          ),
        ],
      ),
      onPressed: () => provider.isLogin = !provider.isLogin,
    );
  }

  Future submit(BuildContext context) async {
    final emailProvider =
        Provider.of<EmailSignInProvider>(pageContext, listen: false);

    final isValid = formKey.currentState!.validate();

    FocusScope.of(pageContext).unfocus();

    if (isValid) {
      formKey.currentState!.save();
      final isSuccess = await emailProvider.login();

      if (isSuccess) {
        emailProvider.isLogin
            ? Navigator.pop(context)
            : Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => EmailVerifyScreen()));
      } else {
        final message =
            'Please check your credentials or create a new account if you haven\'t!';

        ScaffoldMessenger.of(pageContext).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(pageContext).errorColor,
          ),
        );
      }
    }
  }
}
