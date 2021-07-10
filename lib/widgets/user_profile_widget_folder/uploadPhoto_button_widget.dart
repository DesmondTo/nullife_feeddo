import 'package:flutter/material.dart';

class UploadImageButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  const UploadImageButtonWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color.fromRGBO(29, 194, 95, 1),
        minimumSize: Size.fromHeight(50),
      ),
      onPressed: this.onClicked,
      child: buildContent(),
    );
  }

  Widget buildContent() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            this.icon,
            size: 28,
          ),
          SizedBox(
            width: 16,
          ),
          Text(
            this.text,
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        ],
      );
}
