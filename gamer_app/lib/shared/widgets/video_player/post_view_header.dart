import 'package:flutter/material.dart';

class PostViewHeader extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final String timeAgo;
  final VoidCallback onProfileTap;
  final VoidCallback? onOptionsTap;

  const PostViewHeader({
    super.key,
    required this.username,
    required this.avatarUrl,
    required this.timeAgo,
    required this.onProfileTap,
    this.onOptionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onProfileTap,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[800],
                  backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl.isEmpty ? const Icon(Icons.person, color: Colors.white70, size: 20) : null,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          username,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.check_circle, color: Color(0xFFE50914), size: 14),
                      ],
                    ),
                    Text(timeAgo, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: onOptionsTap,
          ),
        ],
      ),
    );
  }
}