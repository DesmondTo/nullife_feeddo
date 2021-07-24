import 'package:flutter/material.dart';

class TimeTextFormWidget extends StatelessWidget {
  final TextEditingController timeController;
  final String unit;

  TimeTextFormWidget({
    Key? key,
    required this.timeController,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 24),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Add $unit',
      ),
      keyboardType: TextInputType.number,
      onFieldSubmitted: (_) {},
      validator: (title) => title != null && title.isEmpty
          ? '$unit cannot be empty'
          : title != null && allSpace(title)
              ? '$unit cannot contains only whitespace'
              : title != null && checkRange(int.parse(title))
                  ? 'Out of range'
                  : null,
      controller: timeController,
    );
  }

  bool allSpace(String title) {
    return title.runes
        .fold(true, (previousValue, element) => previousValue && element == 32);
  }

  bool checkRange(int duration) {
    if (unit == 'Hour') {
      return duration < 0 || duration >= 126;
    } else {
      return duration < 0 || duration >= 60;
    }
  }
}
