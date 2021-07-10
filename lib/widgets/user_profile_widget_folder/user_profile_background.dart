import 'package:nullife_feeddo/models/user_profile.dart';
import 'package:nullife_feeddo/providers/email_signin_provider.dart';
import 'package:nullife_feeddo/providers/google_signin_provider.dart';
import 'package:nullife_feeddo/screens/account_screen/edit_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileBackground extends StatelessWidget {
  final Widget child;
  final UserProfile userProfile;
  const UserProfileBackground({
    Key? key,
    required this.child,
    required this.userProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              maxRadius: 25,
              backgroundImage: NetworkImage(user?.photoURL ??
                  'https://mspgh.unimelb.edu.au/__data/assets/image/0011/3576098/Placeholder.jpg'),
            ),
            Text(
              user?.displayName ?? 'Unknown',
            ),
            Text(
              user?.email ?? 'WALAO',
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileEdittingScreen(
                              userProfile: this.userProfile,
                            )));
              },
              child: Text('Edit Profile'),
            ),
            ElevatedButton(
              onPressed: () {
                final googleProvider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                final emailProvider =
                    Provider.of<EmailSignInProvider>(context, listen: false);

                googleProvider.logout();
                emailProvider.logout();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
