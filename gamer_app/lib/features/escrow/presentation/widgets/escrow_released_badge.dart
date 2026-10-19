import 'package:flutter/material.dart';

class EscrowReleasedBadge extends StatelessWidget {
  final bool isCompact;

  const EscrowReleasedBadge({Key? key, this.isCompact = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF00E676).withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF00E676), width: 0.8),
      ),
      child: const Text(
        'COMPLETED',
        style: TextStyle(
          color: Color(0xFF00E676),
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}