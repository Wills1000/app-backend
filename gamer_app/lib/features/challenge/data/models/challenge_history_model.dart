import '../../domain/entities/challenge_history.dart';

class ChallengeHistoryModel extends ChallengeHistoryItem {
  const ChallengeHistoryModel({
    required String id,
    required String gameTitle,
    required String mode,
    required String opponentUsername,
    required String result,
    required String score,
    required double wager,
    required String timeAgo,
  }) : super(
          id: id,
          gameTitle: gameTitle,
          mode: mode,
          opponentUsername: opponentUsername,
          result: result,
          score: score,
          wager: wager,
          timeAgo: timeAgo,
        );

  factory ChallengeHistoryModel.fromJson(Map<String, dynamic> json) {
    return ChallengeHistoryModel(
      id: json['id'],
      gameTitle: json['gameTitle'],
      mode: json['mode'],
      opponentUsername: json['opponentUsername'],
      result: json['result'],
      score: json['score'],
      wager: (json['wager'] as num).toDouble(),
      timeAgo: json['timeAgo'],
    );
  }
}