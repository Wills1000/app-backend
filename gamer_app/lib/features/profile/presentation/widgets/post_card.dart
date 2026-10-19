import 'package:flutter/material.dart';
import 'package:gamer_app/features/feed/presentation/pages/post_view_screen.dart';

class PostCard extends StatelessWidget {
  final String postId;
  final String thumbnailUrl;
  final String title;
  final String views;

  const PostCard({
    super.key,
    this.postId = '1',
    required this.thumbnailUrl,
    required this.title,
    required this.views,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PostViewScreen(
              postId: postId,
              videoUrl: thumbnailUrl,
              caption: title,
              username: 'Princewill',
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.network(
              thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey[900]),
            ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.transparent,
                    Colors.black.withOpacity(0.85),
                  ],
                ),
              ),
            ),

            // Context Menu Icon
            const Positioned(
              top: 6,
              right: 6,
              child: Icon(Icons.more_vert, color: Colors.white, size: 18),
            ),

            // Play Count Tag
            Positioned(
              left: 8,
              bottom: 8,
              child: Row(
                children: [
                  const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 2),
                  Text(
                    views,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}