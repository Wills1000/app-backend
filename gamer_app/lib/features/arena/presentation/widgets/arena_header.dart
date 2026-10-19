import 'package:flutter/material.dart';
import 'package:gamer_app/features/challenge/presentation/pages/challenge_creation_screen.dart';
import 'package:gamer_app/features/guide/presentation/pages/guide_screen.dart';

class ArenaHeader extends StatelessWidget {
  final VoidCallback onFilterTap;

  const ArenaHeader({
    super.key,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Arena',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ChallengeCreationScreen(),
      ),
    );
  },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              IconButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const GuideScreen(),
      ),
    );
  },
  icon: const Icon(
    Icons.menu_book_rounded,
    color: Color(0xffE50914),
  ),
),
            ],
          ),
        ],
      ),
    );
  }
}