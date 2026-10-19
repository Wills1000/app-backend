// stat_tile.dart
import 'package:flutter/material.dart';

class StatTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  static const Color primaryRed = Color(0xFF970303);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: primaryRed, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// stats_grid.dart
class StatsGrid extends StatelessWidget {
  final int wins;
  final int losses;
  final int matches;
  final String winRate;
  final int friends;
  final int following;

  const StatsGrid({
    super.key,
    required this.wins,
    required this.losses,
    required this.matches,
    required this.winRate,
    required this.friends,
    required this.following,
  });

  static const Color cardBg = Color.fromARGB(255, 0, 0, 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Table(
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.white.withOpacity(0.06), width: 1),
          verticalInside: BorderSide(color: Colors.white.withOpacity(0.06), width: 1),
        ),
        children: [
          TableRow(
            children: [
              StatTile(title: 'Wins', value: '$wins', icon: Icons.emoji_events_outlined),
              StatTile(title: 'Losses', value: '$losses', icon: Icons.shield_outlined),
              StatTile(title: 'Matches', value: '$matches', icon: Icons.sports_esports_outlined),
            ],
          ),
          TableRow(
            children: [
              StatTile(title: 'Win Rate', value: winRate, icon: Icons.ads_click_outlined),
              StatTile(title: 'Friends', value: '$friends', icon: Icons.people_outline),
              StatTile(title: 'Following', value: '$following', icon: Icons.person_add_alt_outlined),
            ],
          ),
        ],
      ),
    );
  }
}