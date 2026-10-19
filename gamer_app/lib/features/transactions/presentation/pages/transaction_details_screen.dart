import 'package:flutter/material.dart';

import '/../../core/widgets/app_background.dart';
import '../../models/transaction_model.dart';
import '../widgets/transaction_amount.dart';
import '../widgets/transaction_header.dart';
import '../widgets/transaction_status_chip.dart';

class TransactionDetailsScreen extends StatelessWidget {
  static const String routeName = '/transaction-details';

  final TransactionModel transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  static const Color accentRed = Color(0xFFFF2233);
  static const Color cardBg = Color(0xFF121215);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: const Text(
          'Transaction Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded, color: Colors.white, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 8),

                // Icon Header
                const TransactionHeader(),
                const SizedBox(height: 14),

                // Title & Status Chip
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                TransactionStatusChip(status: transaction.status),
                const SizedBox(height: 12),

                // Transaction Amount
                TransactionAmount(
                  coins: transaction.coins,
                  isCredit: transaction.isCredit,
                  fontSize: 32,
                  showBadge: true,
                ),
                const SizedBox(height: 4),
                Text(
                  '≈ ₦${_formatDecimal(transaction.nairaEquivalent)}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),

                // Details Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: Column(
                    children: [
                      _buildRow('Transaction ID', transaction.id),
                      _buildDivider(),
                      _buildRow('Date', transaction.timestamp),
                      _buildDivider(),
                      _buildRow('Type', _formatTypeName(transaction.type)),
                      _buildDivider(),
                      _buildRow('From', transaction.from),
                      _buildDivider(),
                      _buildRow('To', transaction.to),
                      _buildDivider(),
                      _buildRowWithCoinBadge(
                        'Coins',
                        '${transaction.isCredit ? '+' : '-'}${transaction.coins.abs()}',
                        transaction.isCredit,
                      ),
                      _buildDivider(),
                      _buildRow('Equivalent', '≈ ₦${_formatDecimal(transaction.nairaEquivalent)}'),
                      _buildDivider(),
                      _buildRow('Rate', '100 G = ₦1,500'),
                      _buildDivider(),
                      _buildRow('Status', transaction.status, valueColor: const Color(0xFF00E676)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Match Info Card (if applicable)
                if (transaction.matchType != null) ...[
                  _buildMatchCard(
                    matchTitle: transaction.matchType!,
                    opponentName: transaction.opponentName ?? 'Opponent',
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMatchCard({required String matchTitle, required String opponentName}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Match Info',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 90,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withOpacity(0.85),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  matchTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'vs $opponentName',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowWithCoinBadge(String label, String value, bool isCredit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          TransactionAmount(
            coins: int.parse(value),
            isCredit: isCredit,
            fontSize: 12,
            showBadge: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        color: Colors.white.withOpacity(0.04),
        height: 1,
      ),
    );
  }

  String _formatTypeName(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return 'Deposit';
      case TransactionType.matchWon:
        return 'Match Won';
      case TransactionType.matchEntry:
        return 'Match Entry';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      case TransactionType.referralBonus:
        return 'Referral Bonus';
      case TransactionType.tournamentPrize:
        return 'Tournament Prize';
    }
  }

  String _formatDecimal(double val) {
    return val.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}