import 'package:flutter/material.dart';

class TitleTextFormWidget extends StatelessWidget {
  final TextEditingController titleController;

  TitleTextFormWidget({
    Key? key,
    required this.titleController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 24),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Add Title',
      ),
      onFieldSubmitted: (_) {},
      validator: (title) => title != null && title.isEmpty
          ? 'Title cannot be empty'
          : title != null && allSpace(title)
              ? 'Title cannot contains only whitespace'
              : null,
      controller: titleController,
    );
  }

  bool allSpace(String title) {
    return title.runes
        .fold(true, (previousValue, element) => previousValue && element == 32);
  }
}
