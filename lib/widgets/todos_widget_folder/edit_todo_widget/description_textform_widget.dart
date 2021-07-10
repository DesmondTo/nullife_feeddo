import 'package:flutter/material.dart';

class DescriptionTextFormWidget extends StatelessWidget {
  final TextEditingController descriptionController;

  DescriptionTextFormWidget({
    Key? key,
    required this.descriptionController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 24),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Add Description',
      ),
      onFieldSubmitted: (_) {},
      validator: null,
      controller: descriptionController,
    );
  }
}
