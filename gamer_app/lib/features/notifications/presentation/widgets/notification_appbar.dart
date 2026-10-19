import 'package:flutter/material.dart';

class NotificationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NotificationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0, // Prevents background color shift when scrolling
      centerTitle: true,
      title: const Text(
        'Notifications',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white, size: 24),
          onPressed: () {
            // Search action
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white, size: 24),
          onPressed: () {
            // More options menu
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}