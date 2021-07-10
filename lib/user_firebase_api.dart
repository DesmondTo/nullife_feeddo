import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nullife_feeddo/models/user_profile.dart';
import 'package:nullife_feeddo/utils.dart';

class UserFirebaseApi {
  static Future<String> createUser(UserProfile userProfile) async {
    final docUserProfile =
        FirebaseFirestore.instance.collection('userProfile').doc();

    userProfile.firestoreID = docUserProfile.id;
    await docUserProfile.set(userProfile.toJson());

    return docUserProfile.id;
  }

  static Stream<List<UserProfile>> readUsersByUID(String userID) =>
      FirebaseFirestore.instance
          .collection('userProfile')
          .where('userID', isEqualTo: userID)
          .snapshots()
          .transform(Utils.transformer(UserProfile.fromJson));

  static Future updateUser(UserProfile userProfile) async {
    final docUser = FirebaseFirestore.instance
        .collection('userProfile')
        .doc(userProfile.firestoreID);

    await docUser.update(userProfile.toJson());
  }
}
