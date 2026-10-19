import 'package:flutter/material.dart';

class TransactionHeader extends StatelessWidget {
  final IconData icon;

  const TransactionHeader({
    super.key,
    this.icon = Icons.sports_kabaddi_rounded,
  });

  static const Color accentRed = Color(0xFFFF2233);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
        border: Border.all(color: accentRed, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentRed.withOpacity(0.35),
            blurRadius: 16,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: accentRed,
          size: 30,
        ),
      ),
    );
  }
}