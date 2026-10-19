import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import 'transaction_amount.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            _buildTypeIcon(transaction.type),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${transaction.subtitle}  •  ${transaction.timestamp}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                TransactionAmount(
                  coins: transaction.coins,
                  isCredit: transaction.isCredit,
                  fontSize: 15,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white.withOpacity(0.3),
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeIcon(TransactionType type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case TransactionType.deposit:
        iconData = Icons.file_download_outlined;
        iconColor = const Color(0xFF00E676);
        break;
      case TransactionType.matchWon:
        iconData = Icons.sports_kabaddi_rounded;
        iconColor = const Color(0xFFFF2233);
        break;
      case TransactionType.matchEntry:
        iconData = Icons.lock_outline_rounded;
        iconColor = const Color(0xFFFF2233);
        break;
      case TransactionType.withdrawal:
        iconData = Icons.account_balance_outlined;
        iconColor = const Color(0xFF9C27B0);
        break;
      case TransactionType.referralBonus:
        iconData = Icons.card_giftcard_rounded;
        iconColor = const Color(0xFFFFB300);
        break;
      case TransactionType.tournamentPrize:
        iconData = Icons.emoji_events_outlined;
        iconColor = const Color(0xFFFFB300);
        break;
    }

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: iconColor.withOpacity(0.1),
        border: Border.all(color: iconColor.withOpacity(0.5), width: 1.2),
      ),
      child: Center(
        child: Icon(iconData, color: iconColor, size: 20),
      ),
    );
  }
}