class ChallengeHistoryItem {
  final String id;
  final String gameTitle;
  final String mode;
  final String opponentUsername;
  final String result; // 'Won', 'Lost', 'Cancelled'
  final String score;
  final double wager;
  final String timeAgo;

  const ChallengeHistoryItem({
    required this.id,
    required this.gameTitle,
    required this.mode,
    required this.opponentUsername,
    required this.result,
    required this.score,
    required this.wager,
    required this.timeAgo,
  });
}