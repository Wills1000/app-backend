import 'package:flutter/material.dart';

class PostViewDetails extends StatelessWidget {
  final String gameTitle;
  final String gameMode;
  final String caption;
  final String hashtags;

  const PostViewDetails({
    super.key,
    required this.gameTitle,
    required this.gameMode,
    required this.caption,
    required this.hashtags,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.amber[800],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.sports_esports, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(gameTitle, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  Text(gameMode, style: const TextStyle(color: Colors.white60, fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          caption.isNotEmpty ? caption : 'Insane 1v4 clutch to win the round! 👿',
          style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
        ),
        const SizedBox(height: 6),
        Text(hashtags, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }
}