import 'package:nullife_feeddo/providers/email_signin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailAuthBackground extends StatelessWidget {
  final Widget child;

  const EmailAuthBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = Provider.of<EmailSignInProvider>(context);

    return provider.isLogin
        ? Container(
            height: size.height,
            width: size.width,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: size.height * 0.1,
                  left: size.width * 0.05,
                  child: Image.asset(
                    "assets/images/email_auth_deco_dot_top_left.png",
                    width: size.width * 0.1,
                    height: size.height * 0.1,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  bottom: -size.height * 0.115,
                  right: size.height * 0.05,
                  child: Image.asset(
                    "assets/images/email_auth_deco_barDot_bot_right.png",
                    width: size.width * 0.5,
                    height: size.height * 0.35,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child,
              ],
            ),
          )
        : Container(
            height: size.height,
            width: size.width,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset(
                    "assets/images/email_auth_footprints_top_left.png",
                    width: size.width * 0.5,
                    height: size.height * 0.35,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  bottom: -size.height * 0.115,
                  right: 0,
                  child: Image.asset(
                    "assets/images/email_auth_footprints_bot_right.png",
                    width: size.width * 0.5,
                    height: size.height * 0.35,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child,
              ],
            ),
          );
  }
}
