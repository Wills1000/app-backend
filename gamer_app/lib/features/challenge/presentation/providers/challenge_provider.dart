import 'package:flutter/material.dart';
import '../../domain/entities/challenge.dart';
import '../../domain/entities/challenge_history.dart';

class ChallengeProvider extends ChangeNotifier {
  String selectedGame = 'Call of Duty: Mobile';
  String selectedMode = 'Team Deathmatch';
  ChallengeType selectedType = ChallengeType.public;
  String selectedRegion = 'North America';
  double wagerAmount = 500;
  List<String> rules = ['No cheating / No hacks', 'Respectful play', 'No toxic behavior'];

  List<ChallengeHistoryItem> historyItems = [];
  bool isLoading = false;

  void updateGame(String game) {
    selectedGame = game;
    notifyListeners();
  }

  void updateMode(String mode) {
    selectedMode = mode;
    notifyListeners();
  }

  void updateType(ChallengeType type) {
    selectedType = type;
    notifyListeners();
  }

  void updateRegion(String region) {
    selectedRegion = region;
    notifyListeners();
  }

  void updateWager(double amount) {
    wagerAmount = amount;
    notifyListeners();
  }
}