import 'package:nullife_feeddo/widgets/entry/entry_page_banner_widget.dart';
import 'package:flutter/material.dart';

class EntryBackground extends StatelessWidget {
  final Widget child;

  const EntryBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: Column(
        children: <Widget>[
          Spacer(
            flex: 2,
          ),
          EntryPageBanner(),
          Spacer(),
          child,
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            child: Image.asset(
              "assets/images/shiba_inu_fat_cheek.png",
              width: size.width,
              height: size.height * 0.4,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
