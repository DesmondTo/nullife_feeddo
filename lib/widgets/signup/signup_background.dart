import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignUpBackground extends StatelessWidget {
  final Widget child;

  const SignUpBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SvgPicture.asset(
            "assets/images/phone_frame.svg",
            width: size.width * 0.9,
            height: size.height * 0.8,
          ),
          child,
        ],
      ),
    );
  }
}
