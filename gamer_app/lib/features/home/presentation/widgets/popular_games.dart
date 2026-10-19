import 'package:flutter/material.dart';

class PopularGames extends StatelessWidget {
  const PopularGames({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> games = [
  {
    'title': 'COD Mobile',
    'img': 'assets/images/games/cod1.jpg',
  },
  {
    'title': 'PUBG Mobile',
    'img': 'assets/images/games/pubg.jpg',
  },
  {
    'title': 'eFootball',
    'img': 'assets/images/games/efootball.jpg',
  },
  {
    'title': 'Free Fire',
    'img': 'assets/images/games/freefire.jpg',
  },
];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return InkWell(
  borderRadius: BorderRadius.circular(16),
  onTap: () {
    // TODO: Open game details
  },
  child: Container(
    width: 120,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              image: DecorationImage(
               image: AssetImage(game['img']!),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.sports_esports,
                      color: Color(0xffE50914), size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      game['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
           ),
          );
        },
      ),
    );
  }
}