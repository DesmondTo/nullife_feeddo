import 'package:nullife_feeddo/models/user_profile.dart';
import 'package:nullife_feeddo/user_firebase_api.dart';
import 'package:flutter/cupertino.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfile? _user;

  UserProfile? getCurrentUser() {
    return this._user;
  }

  void setUsers(List<UserProfile> users) =>
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _user = users[0];
        notifyListeners();
      });

  void addUser(UserProfile userProfile) {
    _user = userProfile;
    UserFirebaseApi.createUser(userProfile);

    notifyListeners();
  }

  void editUser(UserProfile newUser, UserProfile oldProfile) {
    _user = newUser;
    UserFirebaseApi.updateUser(newUser);

    notifyListeners();
  }
}
