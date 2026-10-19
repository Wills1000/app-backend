import 'package:flutter/material.dart';
import 'stat_tile.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent, // Removed background
      ),
      child: Table(
        border: const TableBorder(
          horizontalInside: BorderSide.none, // Removed inner horizontal border
          verticalInside: BorderSide.none,   // Removed inner vertical border
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