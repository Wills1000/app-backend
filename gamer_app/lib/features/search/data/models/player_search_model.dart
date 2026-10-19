class PlayerSearchModel {
  final String id;
  final String username;
  final bool isVerified;
  final int winRate;
  final int matchesCount;
  final String favoriteGame;
  final String avatarUrl;
  final bool isOnline;

  const PlayerSearchModel({
    required this.id,
    required this.username,
    this.isVerified = false,
    required this.winRate,
    required this.matchesCount,
    required this.favoriteGame,
    required this.avatarUrl,
    this.isOnline = false,
  });
}