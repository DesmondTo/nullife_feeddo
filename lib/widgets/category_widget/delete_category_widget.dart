import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nullife_feeddo/models/user_profile.dart';
import 'package:nullife_feeddo/providers/todo_provider.dart';
import 'package:nullife_feeddo/providers/userProfile_provider.dart';
import 'package:provider/provider.dart';

class DeleteCategoryDialog extends StatefulWidget {
  final UserProfile userProfile;
  final int index;
  final String category;

  const DeleteCategoryDialog({
    Key? key,
    required this.userProfile,
    required this.index,
    required this.category,
  }) : super(key: key);

  @override
  _DeleteCategoryDialogState createState() => _DeleteCategoryDialogState();
}

class _DeleteCategoryDialogState extends State<DeleteCategoryDialog> {
  late int index;
  late String category;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    category = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    UserProfileProvider userProvider = Provider.of<UserProfileProvider>(
      context,
      listen: false,
    );
    TodoProvider todoProvider = Provider.of<TodoProvider>(
      context,
      listen: false,
    );

    return AlertDialog(
      title: Text('Are you sure to delete "${widget.category}?"'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('No')),
        TextButton(
            onPressed: () {
              todoProvider.removeTodoByCategory(category);
              widget.userProfile.categoryFieldList.removeAt(index);
              final newUser = UserProfile(
                firestoreID: widget.userProfile.firestoreID,
                userID: widget.userProfile.userID,
                email: widget.userProfile.email,
                userName: widget.userProfile.userName,
                petID: widget.userProfile.petID,
                userPhotoURL: widget.userProfile.userPhotoURL,
                categoryFieldList: widget.userProfile.categoryFieldList,
              );

              userProvider.editUser(newUser, widget.userProfile);
              Navigator.pop(context);
            },
            child: Text('Yes')),
      ],
    );
  }
}
