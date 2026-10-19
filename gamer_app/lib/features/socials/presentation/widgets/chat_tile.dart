import 'package:flutter/material.dart';

class ChatTileData {
  final String name;
  final String avatarUrl;
  final String gameTag;
  final String lastMessage;
  final String time;
  final int? unreadCount;
  final bool isTyping;
  final bool isGroup;
  final IconData? statusIcon;

  const ChatTileData({
    required this.name,
    required this.avatarUrl,
    required this.gameTag,
    required this.lastMessage,
    required this.time,
    this.unreadCount,
    this.isTyping = false,
    this.isGroup = false,
    this.statusIcon,
  });
}

class ChatTile extends StatelessWidget {
  final ChatTileData chat;
  final VoidCallback onTap;

  const ChatTile({
    super.key,
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xff141416), // Dark rounded card background
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            // Avatar with Red Border & Online Badge
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xffE50914), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey[800],
                    backgroundImage: NetworkImage(chat.avatarUrl),
                  ),
                ),
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xff00FF66), // Online Green Indicator
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xff141416), width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Content Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Name + Verified Badge
                  Row(
                    children: [
                      Text(
                        chat.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        color: Color(0xffE50914),
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  // Game Tag
                  Text(
                    chat.gameTag,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Message / Typing Preview
                  Text(
                    chat.isTyping ? 'Typing...' : chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: chat.isTyping
                          ? const Color(0xffE50914)
                          : Colors.white70,
                      fontSize: 13,
                      fontWeight:
                          chat.isTyping ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            // Time & Unread Badge Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat.time,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),

                if (chat.unreadCount != null && chat.unreadCount! > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xffE50914),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${chat.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (chat.statusIcon != null)
                  Icon(
                    chat.statusIcon,
                    color: Colors.white38,
                    size: 16,
                  )
                else
                  const SizedBox(height: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}