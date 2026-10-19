import 'package:flutter/material.dart';

class EscrowLockedBadge extends StatelessWidget {
  final bool isCompact;

  const EscrowLockedBadge({Key? key, this.isCompact = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isCompact) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE50914).withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE50914).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFE50914),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'LOCKED',
                  style: TextStyle(
                    color: Color(0xFFE50914),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Funds are locked in escrow',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE50914).withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE50914), width: 0.8),
      ),
      child: const Text(
        'LOCKED',
        style: TextStyle(
          color: Color(0xFFE50914),
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}