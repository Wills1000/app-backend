import 'package:flutter/material.dart';
import '../../data/models/player_search_model.dart';

class PlayerSearchCard extends StatelessWidget {
  final PlayerSearchModel player;
  final VoidCallback onAddTap;

  const PlayerSearchCard({
    Key? key,
    required this.player,
    required this.onAddTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(player.avatarUrl),
              ),
              if (player.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF16161A), width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      player.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    if (player.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.check_circle, color: Color(0xFFE50914), size: 14),
                    ]
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${player.winRate}% Win Rate • ${player.matchesCount} Matches',
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.sports_esports, color: Colors.white38, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      player.favoriteGame,
                      style: const TextStyle(color: Colors.white38, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: onAddTap,
            icon: const Icon(Icons.person_add, size: 14, color: Color(0xFFE50914)),
            label: const Text(
              'Add',
              style: TextStyle(color: Color(0xFFE50914), fontSize: 11, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE50914)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
          ),
        ],
      ),
    );
  }
}