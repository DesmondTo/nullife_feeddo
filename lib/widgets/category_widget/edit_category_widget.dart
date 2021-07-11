import 'package:flutter/material.dart';
import 'package:nullife_feeddo/models/user_profile.dart';
import 'package:nullife_feeddo/providers/userProfile_provider.dart';
import 'package:nullife_feeddo/widgets/category_widget/category_name_textForm.dart';
import 'package:provider/provider.dart';

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
  final categoryNameController = TextEditingController();
  final colorController = TextEditingController();
  late String categoryString;

  @override
  void initState() {
    super.initState();
    final UserProfile user = widget.userProfile;
    categoryString = user.categoryFieldList[widget.index];
    categoryNameController.text =
        categoryString.substring(0, categoryString.indexOf(":")).trim();
    colorController.text =
        categoryString.substring(categoryString.indexOf(":") + 1).trim();
  }

  @override
  void dispose() {
    categoryNameController.dispose();
    colorController.dispose();

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
      content: Container(
        child: CategoryNameTextFormWidget(
          categoryNameController: categoryNameController,
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
              List<String> newCategoryFieldList =
                  widget.userProfile.categoryFieldList;
              newCategoryFieldList[widget.index] = categoryNameController.text +
                  categoryString.substring(categoryString.indexOf(":")).trim();
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
            },
            child: Text('Save'))
      ],
    );
  }
}
