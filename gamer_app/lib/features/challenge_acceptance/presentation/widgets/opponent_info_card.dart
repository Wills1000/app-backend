import 'package:flutter/material.dart';

class OpponentInfoCard extends StatelessWidget {
  final String username;
  final bool isVerified;
  final String winRate;
  final int totalMatches;

  const OpponentInfoCard({
    super.key,
    required this.username,
    this.isVerified = true,
    required this.winRate,
    required this.totalMatches,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Color(0xFF25252A),
            child: Icon(Icons.person, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.check_circle, color: Color(0xFF00E676), size: 14),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Win Rate: ',
                      style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11),
                    ),
                    Text(
                      winRate,
                      style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Total Matches: ',
                      style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11),
                    ),
                    Text(
                      '$totalMatches',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}