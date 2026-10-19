enum TransactionType {
  deposit,
  matchWon,
  matchEntry,
  withdrawal,
  referralBonus,
  tournamentPrize,
}

class TransactionModel {
  final String id;
  final String title;
  final String subtitle;
  final String timestamp;
  final int coins;
  final TransactionType type;
  final String status;
  final String from;
  final String to;
  final double ratePerCoin;
  final String? opponentName;
  final String? matchType;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.coins,
    required this.type,
    this.status = 'Completed',
    this.from = 'Escrow',
    this.to = 'Your Wallet',
    this.ratePerCoin = 15.0, // 100 G = ₦1,500
    this.opponentName,
    this.matchType,
  });

  bool get isCredit => coins > 0;
  double get nairaEquivalent => coins.abs() * ratePerCoin;
}