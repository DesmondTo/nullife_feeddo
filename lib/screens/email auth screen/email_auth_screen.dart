import 'package:nullife_feeddo/providers/email_signin_provider.dart';
import 'package:nullife_feeddo/widgets/email_auth_widget/actionButton_widget.dart';
import 'package:nullife_feeddo/widgets/email_auth_widget/datePicker_widget.dart';
import 'package:nullife_feeddo/widgets/email_auth_widget/email_textField_widget.dart';
import 'package:nullife_feeddo/widgets/email_auth_widget/password_textField_widget.dart';
import 'package:nullife_feeddo/widgets/email_auth_widget/userName_textField_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'email_auth_background.dart';

class EmailAuthScreen extends StatefulWidget {
  @override
  _EmailAuthScreenState createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(context);

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor:
            provider.isLogin ? Color(0xffD3E9FF) : Color(0xffFCDCB5),
        body: EmailAuthBackground(
          child: buildAuthForm(_formKey),
        ),
      ),
    );
  }

  // Shows a form to fill in email, passwor, etc depending on whether
  // the user is logging in or creating account.
  Widget buildAuthForm(GlobalKey<FormState> formKey) {
    final provider = Provider.of<EmailSignInProvider>(context);
    final size = MediaQuery.of(context).size;

    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  EmailTextField(),
                  SizedBox(height: size.height * 0.01),
                  if (!provider.isLogin) UserNameTextField(),
                  if (!provider.isLogin) SizedBox(height: size.height * 0.01),
                  if (!provider.isLogin) DatePicker(),
                  if (!provider.isLogin) SizedBox(height: size.height * 0.01),
                  PasswordTextField(),
                  SizedBox(height: size.height * 0.05),
                  ActionButton(pageContext: context, formKey: _formKey),
                ],
              ),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
            color: Colors.white,
            width: 3,
          ),
        ),
        color: Colors.deepOrange[100],
      ),
    );
  }
}
