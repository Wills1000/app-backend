import 'package:flutter/material.dart';
import 'package:gamer_app/shared/widgets/notification_button.dart';
import 'package:gamer_app/features/search/presentation/pages/search_screen.dart';

class FeedHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSearchTap;

  const FeedHeader({
    super.key,
    this.onNotificationTap,
    this.onSearchTap,
  });
             
  @override 
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo Area on Top Left
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
                'FEED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          // Actions Right
          Row(
            children: [
              IconButton(
                onPressed: onSearchTap ?? () {
                  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const SearchScreen(),
    ),
  );
                },
                icon: const Icon(Icons.search, color: Colors.white, size: 24),
              ),
              Stack(
                children: [
                  
  const NotificationButton(),

                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xffE50914),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}