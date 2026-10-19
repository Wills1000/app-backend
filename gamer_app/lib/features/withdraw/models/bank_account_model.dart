class BankAccountModel {
  final String id;
  final String bankName;
  final String accountNumberMasked;
  final String accountName;
  final String? logoUrl;

  const BankAccountModel({
    required this.id,
    required this.bankName,
    required this.accountNumberMasked,
    required this.accountName,
    this.logoUrl,
  });
}