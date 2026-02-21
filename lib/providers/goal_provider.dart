import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../services/api_service.dart';

class GoalProvider with ChangeNotifier {
  List<Goal> _goals = [];
  bool _isLoading = false;

  List<Goal> get goals => _goals;
  bool get isLoading => _isLoading;

  Future<void> loadGoals() async {
    _isLoading = true;
    notifyListeners();

    try {
      _goals = await ApiService.getGoals();
    } catch (e) {
      _goals = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addGoal(Goal goal) async {
    try {
      final newGoal = await ApiService.createGoal(goal);
      _goals.add(newGoal);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }
}