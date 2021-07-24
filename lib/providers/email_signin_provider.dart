import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EmailSignInProvider extends ChangeNotifier {
  // To show the loading indicator if is loading.
  bool _isLoading = false;
  // To determine if the user has successfully log in.
  bool _isLogin = true;
  // The followings are used to store the user's particulars.
  String _userEmail = '';
  String _userPassword = '';
  String _userName = '';
  String _petName = '';
  String _userPhotoURL = '';
  String _petPhotoURL = '';
  DateTime _dateOfBirth = DateTime.now();

  EmailSignInProvider() {
    _isLoading = false;
    _isLogin = true;
    _userEmail = '';
    _userPassword = '';
    _userName = '';
    _petName = '';
    _userPhotoURL = '';
    _petPhotoURL = '';
    _dateOfBirth = DateTime.now();
  }

  // These two getters and setters are to notify the progress of sign in/up
  // and show the loading indicator/button accordingly.
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isLogin => _isLogin;

  set isLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  // Similarly, the following setters and getters allow us to retrieve and set
  // the particulars of the user.
  String get userEmail => _userEmail;

  set userEmail(String value) {
    _userEmail = value;
    notifyListeners();
  }

  String get userPassword => _userPassword;

  set userPassword(String value) {
    _userPassword = value;
    notifyListeners();
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
    notifyListeners();
  }

  String get petName => _petName;

  set petName(String value) {
    _petName = value;
    notifyListeners();
  }

  String get userPhotoURL => _userPhotoURL;

  set userPhotoURL(String value) {
    _userPhotoURL = value;
    notifyListeners();
  }

  String get petPhotoURL => _petPhotoURL;

  set petPhotoURL(String value) {
    _petPhotoURL = value;
    notifyListeners();
  }

  DateTime get dateOfBirth => _dateOfBirth;

  set dateOfBirth(DateTime value) {
    _dateOfBirth = value;
    notifyListeners();
  }

  // Handle the login logic when the user:
  // If the user is logging in, then sign in with the email and password inputted.
  // Else, create user account with the email and password inputted.
  Future<bool> login(BuildContext context) async {
    try {
      isLoading = true;

      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );
      }
      // Indicate that the user had successfully sign in/up.
      isLoading = false;
      return true;
    } catch (err) {
      // Failed to sign in/up.
      String errMessage = err.toString();
      int idx = errMessage.indexOf("]");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errMessage.substring(idx + 1).trim()),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      isLoading = false;
      return false;
    }
  }

  // Sign out the user from firebase email authentication service.
  void logout() async {
    FirebaseAuth.instance.signOut();
  }
}
