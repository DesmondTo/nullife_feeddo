import 'package:nullife_feeddo/Goal_firebase_api.dart';
import 'package:nullife_feeddo/models/goal_model.dart';
import 'package:flutter/cupertino.dart';

class GoalProvider extends ChangeNotifier {
  List<Goal> _goals = [];

  List<Goal> get goals => _goals;

  void setGoals(List<Goal> goals) =>
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _goals = goals;
        notifyListeners();
      });

  void addGoal(Goal goal) {
    _goals.add(goal);
    GoalFirebaseApi.createGoal(goal);

    notifyListeners();
  }

  void removeGoal(Goal goal) {
    GoalFirebaseApi.deleteGoal(goal);
    _goals.remove(goal);

    notifyListeners();
  }

  void editGoal(Goal newGoal, Goal oldGoal) {
    final index = _goals.indexWhere((element) => element.id == oldGoal.id);
    _goals[index] = newGoal;
    GoalFirebaseApi.updateGoal(newGoal);

    notifyListeners();
  }
}
