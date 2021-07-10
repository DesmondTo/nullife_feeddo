import 'package:nullife_feeddo/widgets/entry/entry_background.dart';
import 'package:nullife_feeddo/widgets/entry/login_button_widget.dart';
import 'package:nullife_feeddo/widgets/entry/signup_button_widget.dart';
import 'package:flutter/material.dart';

class EntryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return EntryBackground(
      child: SingleChildScrollView(
        child: buildEntry(context, size),
      ),
    );
  }

  Widget buildEntry(BuildContext context, Size screenSize) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 12),
          LogInButton(),
          SizedBox(height: 12),
          SignUpButton(),
          SizedBox(height: 12),
        ],
      );
}
