import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryNameTextFormWidget extends StatelessWidget {
  final TextEditingController categoryNameController;
  static final validCharacters = RegExp(r'^[a-zA-Z0-9 ]*$');

  CategoryNameTextFormWidget({
    Key? key,
    required this.categoryNameController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        style: GoogleFonts.boogaloo(
          fontSize: 24,
        ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'Change Category Name',
          contentPadding: EdgeInsets.only(left: 50, right: 50),
          hintStyle: TextStyle(color: Color.fromRGBO(29, 20, 13, 1)),
          filled: true,
          fillColor: Color.fromRGBO(255, 248, 232, 1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide:
                BorderSide(color: Color.fromRGBO(29, 20, 13, 1), width: 3),
          ),
        ),
        onFieldSubmitted: (_) {},
        validator: (categoryName) => categoryName != null &&
                categoryName.isEmpty
            ? 'Cannot be empty'
            : categoryName != null && !validCharacters.hasMatch(categoryName)
                ? 'Only alphanumeric\nand space allowed'
                : categoryName != null && allSpace(categoryName)
                    ? 'Cannot contains\nonly whitespace(s)'
                    : null,
        controller: categoryNameController,
      ),
    );
  }

  bool allSpace(String title) {
    return title.runes
        .fold(true, (previousValue, element) => previousValue && element == 32);
  }
}
