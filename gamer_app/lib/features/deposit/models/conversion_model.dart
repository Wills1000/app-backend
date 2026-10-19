class ConversionModel {
  final double rateNaira; // e.g., 1500.00
  final int rateCoins;    // e.g., 100

  const ConversionModel({
    required this.rateNaira,
    required this.rateCoins,
  });

  int calculateCoins(double nairaAmount) {
    if (rateNaira <= 0) return 0;
    return ((nairaAmount / rateNaira) * rateCoins).floor();
  }
}