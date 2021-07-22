import 'package:flutter/material.dart';

class CategoryTitleTextFormWidget extends StatelessWidget {
  final TextEditingController categoryTitleController;

  CategoryTitleTextFormWidget({
    Key? key,
    required this.categoryTitleController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 24),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Add a Category goal',
      ),
      onFieldSubmitted: (_) {},
      validator: (title) => title != null && title.isEmpty
          ? 'A category cannot be empty'
          : title != null && allSpace(title)
              ? 'A category cannot contains only whitespace'
              : null,
      controller: categoryTitleController,
    );
  }

  bool allSpace(String title) {
    return title.runes
        .fold(true, (previousValue, element) => previousValue && element == 32);
  }
}
