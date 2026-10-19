import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String description;

  const EmptyState({
    super.key,
    this.title = 'No Challenges Found',
    this.description = 'Try adjusting your filters or search keywords to find open matches.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xff18181B),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sports_esports_outlined,
                size: 48,
                color: Colors.white38,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}