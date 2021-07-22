import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nullife_feeddo/models/goal_model.dart';
import 'package:nullife_feeddo/utils.dart';

class GoalFirebaseApi {
  static Future<String> createGoal(Goal goal) async {
    final docGoal = FirebaseFirestore.instance.collection('goal').doc();

    goal.id = docGoal.id;
    await docGoal.set(goal.toJson());

    return docGoal.id;
  }

  static Stream<List<Goal>> readGoals(String userId) =>
      FirebaseFirestore.instance
          .collection('goal')
          .orderBy(GoalField.createdTime, descending: true)
          .where('userId', isEqualTo: userId)
          .snapshots()
          .transform(Utils.transformer(Goal.fromJson));

  static Future updateGoal(Goal goal) async {
    final docGoal = FirebaseFirestore.instance.collection('goal').doc(goal.id);

    await docGoal.update(goal.toJson());
  }

  static Future deleteGoal(Goal goal) async {
    final docGoal = FirebaseFirestore.instance.collection('goal').doc(goal.id);

    await docGoal.delete();
  }
}
