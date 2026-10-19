import 'package:flutter/material.dart';

class TransactionStatusChip extends StatelessWidget {
  final String status;

  const TransactionStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      status,
      style: const TextStyle(
        color: Color(0xFF00E676),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}