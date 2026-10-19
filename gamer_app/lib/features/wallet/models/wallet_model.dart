class WalletModel {
  final double availableBalance;
  final double lockedBalance;

  const WalletModel({
    this.availableBalance = 0,
    this.lockedBalance = 0,
  });

  double get totalBalance => availableBalance + lockedBalance;

  WalletModel copyWith({
    double? availableBalance,
    double? lockedBalance,
  }) {
    return WalletModel(
      availableBalance: availableBalance ?? this.availableBalance,
      lockedBalance: lockedBalance ?? this.lockedBalance,
    );
  }
}