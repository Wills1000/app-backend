import 'package:flutter/material.dart';

enum TransactionStatus { completed, locked, pending, failed }

class TransactionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String dateText;
  final int coinAmount;
  final bool isPositive;
  final TransactionStatus status;
  final IconData icon;
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.dateText,
    required this.coinAmount,
    required this.isPositive,
    required this.status,
    required this.icon,
    this.onTap,
  });

  static const Color accentRed = Color(0xFFFF2233);

  @override
Widget build(BuildContext context) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),

    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),

      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(
                color: _getIconBorderColor().withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Icon(icon, color: _getIconBorderColor(), size: 18),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 1),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  dateText,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    '${isPositive ? "+" : ""}$coinAmount',
                    style: TextStyle(
                      color: isPositive
                          ? const Color(0xFF4EFE80)
                          : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 3),

                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: accentRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.shield,
                        color: Colors.black,
                        size: 8,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 2),

              Text(
                _getStatusLabel(),
                style: TextStyle(
                  color: _getStatusColor(),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  Color _getIconBorderColor() {
    switch (status) {
      case TransactionStatus.completed:
        return isPositive ? const Color(0xFF4EFE80) : const Color(0xFF7052FF);
      case TransactionStatus.locked:
        return accentRed;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel() {
    switch (status) {
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.locked:
        return 'Locked';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }

  Color _getStatusColor() {
    switch (status) {
      case TransactionStatus.completed:
        return const Color(0xFF4EFE80);
      case TransactionStatus.locked:
        return const Color(0xFFFFB703);
      case TransactionStatus.pending:
        return const Color(0xFFB5179E);
      case TransactionStatus.failed:
        return const Color(0xFFFF2233);
    }
  }
}