import 'package:flutter/material.dart';

class TransactionAmount extends StatelessWidget {
  final int coins;
  final bool isCredit;
  final double fontSize;
  final bool showBadge;

  const TransactionAmount({
    super.key,
    required this.coins,
    required this.isCredit,
    this.fontSize = 15,
    this.showBadge = false,
  });

  static const Color greenCredit = Color(0xFF00E676);
  static const Color redDebit = Color(0xFFFF2233);

  @override
  Widget build(BuildContext context) {
    final color = isCredit ? greenCredit : redDebit;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${isCredit ? '+' : ''}$coins',
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showBadge) ...[
          const SizedBox(width: 6),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(color: redDebit, width: 1.5),
            ),
            child: const Center(
              child: Icon(Icons.shield, color: redDebit, size: 10),
            ),
          ),
        ],
      ],
    );
  }
}