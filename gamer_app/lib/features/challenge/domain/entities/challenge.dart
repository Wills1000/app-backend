enum ChallengeType { public, private }

class Challenge {
  final String id;
  final String gameName;
  final String gameMode;
  final ChallengeType type;
  final String region;
  final double wagerAmount;
  final List<String> rules;
  final String hostUsername;
  final String hostAvatar;
  final String status; // 'Active', 'Completed', 'Cancelled'
  final int currentParticipants;
  final int maxParticipants;

  const Challenge({
    required this.id,
    required this.gameName,
    required this.gameMode,
    required this.type,
    required this.region,
    required this.wagerAmount,
    required this.rules,
    required this.hostUsername,
    required this.hostAvatar,
    required this.status,
    required this.currentParticipants,
    required this.maxParticipants,
  });
}