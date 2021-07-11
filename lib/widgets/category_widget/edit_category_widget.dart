import 'package:flutter/material.dart';
import 'package:nullife_feeddo/models/user_profile.dart';
import 'package:nullife_feeddo/providers/userProfile_provider.dart';
import 'package:nullife_feeddo/widgets/category_widget/category_name_textForm.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditCategoryDialog extends StatefulWidget {
  final UserProfile userProfile;
  final int index;
  const EditCategoryDialog({
    Key? key,
    required this.userProfile,
    required this.index,
  }) : super(key: key);

  @override
  _EditCategoryDialogState createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final categoryNameController = TextEditingController();
  late String categoryString;
  late Color color;

  @override
  void initState() {
    super.initState();
    final UserProfile user = widget.userProfile;
    categoryString = user.categoryFieldList[widget.index];
    categoryNameController.text =
        categoryString.substring(0, categoryString.indexOf(":")).trim();
    color = Color(int.parse(
        categoryString.substring(categoryString.indexOf(":") + 1).trim()));
  }

  @override
  void dispose() {
    categoryNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(
      context,
      listen: false,
    );
    return AlertDialog(
      backgroundColor: Color(0xFFF5F5DC),
      title: Text('Change category name and pick a color'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _formKey,
              child: CategoryNameTextFormWidget(
                categoryNameController: categoryNameController,
              ),
            ),
            ColorPicker(
              colorPickerWidth: 300,
              onColorChanged: (Color color) {
                setState(() {
                  this.color = color;
                });
              },
              pickerColor: this.color,
              enableAlpha: false,
              showLabel: false,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel')),
        TextButton(
            onPressed: () {
              print('The color is: ' + this.color.toString());
              final isValid = _formKey.currentState!.validate();
              if (isValid) {
                widget.userProfile.categoryFieldList[widget.index] =
                    categoryNameController.text +
                        ":" +
                        this.color.toString().substring(6, 16);
                final newUser = UserProfile(
                    firestoreID: widget.userProfile.firestoreID,
                    userID: widget.userProfile.userID,
                    petID: widget.userProfile.petID,
                    email: widget.userProfile.email.toLowerCase(),
                    userName: widget.userProfile.userName,
                    userPhotoURL: widget.userProfile.userPhotoURL,
                    categoryFieldList: widget.userProfile.categoryFieldList);
                userProfileProvider.editUser(newUser, widget.userProfile);
                Navigator.pop(context);
              }
            },
            child: Text('Save'))
      ],
    );
  }
}
