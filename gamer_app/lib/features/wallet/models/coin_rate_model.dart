class CurrencyRateModel {
  final String code;
  final String name;
  final double ratePerCoin;
  final String symbol;
  final String flagAssetOrUrl;

  const CurrencyRateModel({
    required this.code,
    required this.name,
    required this.ratePerCoin,
    required this.symbol,
    required this.flagAssetOrUrl,
  });

  String get formattedValue => '$symbol${ratePerCoin.toStringAsFixed(2)}';
}