import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  // GoogleSignIn allows you to authenticate Google users.
  final googleSignIn = GoogleSignIn();
  // Whether user is currently signing in,
  // For the use of loading indicator later.
  late bool _isSigningIn;
  String _userEmail = '';
  String _userPassword = '';
  String _userName = '';
  String _petName = '';
  String _userPhotoURL = '';
  String _petPhotoURL = '';
  DateTime _dateOfBirth = DateTime.now();

  GoogleSignInProvider() {
    _isSigningIn = false;
    _userName = '';
    _petName = '';
    _userPhotoURL = '';
    _petPhotoURL = '';
    _dateOfBirth = DateTime.now();
  }

  // Getter to determine if the user is currently in the proccess of signing in.
  bool get isSigningIn => _isSigningIn;

  // Setter to change the status of sigining in, then notify the provider up the tree.
  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

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

  Future<void> login() async {
    // Set to true, so will start showing the loading indicator when we
    // just started signing in
    isSigningIn = true;

    // If successfully signing in, return a GoogleSignInAccount.
    // GoogleSignInAccount stores user's particular like name, email, etc.
    final user = await googleSignIn.signIn();

    if (user == null) {
      // If there is no active user, quit login.
      isSigningIn = false;
      return;
    } else {
      // Store google authentication for the user
      final googleAuth = await user.authentication;

      // With the authentication, we can initialize the credential instance,
      // using the accessToken and idToken obtained from the authentication.
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // With the credential, we will be able to signin with google through firebase.
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Successfully logged in, therefore, no more signing process going,
      // it hides the loading indicator.
      isSigningIn = false;
    }
  }

  void logout(BuildContext context) async {
    // Using the google sign in (class field) above, we declare to disconnect
    // from google signin service
    await googleSignIn.disconnect();
    // Since we connect to google through firebase, we also want to stop
    // the firebase when we no longer use its service
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }
}
