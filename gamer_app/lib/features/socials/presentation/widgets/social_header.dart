import 'package:flutter/material.dart';
import 'package:gamer_app/shared/widgets/notification_button.dart';
import 'package:gamer_app/features/search/presentation/pages/search_screen.dart';

class SocialHeader extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;

  const SocialHeader({
    super.key,
    this.onSearchTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xffE50914),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.sports_esports,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Chats',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const SearchScreen(
      initialTab: 2,
    ),
  ),
);
},
                icon: const Icon(Icons.search, color: Colors.white, size: 24),
              ),
              Stack(
                children: [
                  const NotificationButton()
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}