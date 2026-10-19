import 'package:flutter/material.dart';

class UserProfileHeader extends StatefulWidget {
  final String name;
  final String username;
  final String country;
  final String bio;
  final String avatarUrl;
  final int level;
  final bool isOnline;
  final VoidCallback? onChallenge;

  const UserProfileHeader({
    super.key,
    required this.name,
    required this.username,
    required this.country,
    required this.bio,
    required this.avatarUrl,
    required this.level,
    this.isOnline = true,
    this.onChallenge,
  });

  @override
  State<UserProfileHeader> createState() => _UserProfileHeaderState();
}

class _UserProfileHeaderState extends State<UserProfileHeader> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with Level & Online Status
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF970303), width: 2),
                    image: DecorationImage(
                      image: NetworkImage(widget.avatarUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -4,
                  left: 18,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF970303), width: 1),
                    ),
                    child: Text(
                      'Lv. ${widget.level}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (widget.isOnline)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00FF66),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF970303), size: 16),
                    ],
                  ),
                  Text(
                    '@${widget.username}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('🇳🇬 ', style: TextStyle(fontSize: 12)),
                      Text(
                        widget.country,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Bio
        Text(
          widget.bio,
          style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 16),

        // Action Buttons: Follow / Following & Challenge
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => isFollowing = !isFollowing),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: isFollowing ? const Color(0xFF1B1B1E) : const Color(0xFF970303),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isFollowing ? Colors.white24 : const Color(0xFF970303),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isFollowing ? Icons.check_rounded : Icons.person_add_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isFollowing ? 'Following' : 'Follow',
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: widget.onChallenge,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1B1E),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sports_esports_rounded, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Challenge',
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}