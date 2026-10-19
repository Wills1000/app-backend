import 'package:flutter/material.dart';
import 'chat_tile.dart';
import 'package:gamer_app/core/navigation/scroll_aware.dart';

class ChatList extends StatelessWidget {
  final int selectedTabIndex; // 0: All, 1: Unread, 2: Groups
  final Function(ChatTileData)? onChatSelected;

  const ChatList({
    super.key,
    this.selectedTabIndex = 0,
    this.onChatSelected,
  });

  // Dummy chats list (added isGroup field for demonstration)
  static final List<ChatTileData> dummyChats = const [
    ChatTileData(
      name: 'DaPrince',
      avatarUrl: 'https://placeholder.co/100',
      gameTag: 'Call of Duty Mobile',
      lastMessage: "Let's run it back later tonight 💪",
      time: '9:40 PM',
      unreadCount: 2,
    ),
    ChatTileData(
      name: 'KingTobi',
      avatarUrl: 'https://placeholder.co/100',
      gameTag: 'PUBG Mobile',
      lastMessage: '',
      time: '9:38 PM',
      isTyping: true,
    ),
    ChatTileData(
      name: 'Ghostzy',
      avatarUrl: 'https://placeholder.co/100',
      gameTag: 'eFootball',
      lastMessage: 'Nice goal bro! 🔥⚽',
      time: '9:31 PM',
      unreadCount: 1,
    ),
    ChatTileData(
      name: 'QueenB',
      avatarUrl: 'https://placeholder.co/100',
      gameTag: 'Free Fire',
      lastMessage: "You: I'll join the room in 5 mins",
      time: '8:15 PM',
      statusIcon: Icons.done_all,
    ),
    ChatTileData(
      name: 'EagleEye',
      avatarUrl: 'https://placeholder.co/100',
      gameTag: 'Call of Duty Mobile',
      lastMessage: 'Wanna team up for the tournament?',
      time: '7:50 PM',
      unreadCount: 3,
    ),
    // Example Group Chat
    ChatTileData(
      name: 'COD Mobile Squad',
      avatarUrl: 'https://placeholder.co/100',
      gameTag: 'Group • 5 members',
      lastMessage: 'Alex: Scrims starting in 10 mins!',
      time: '6:20 PM',
      isGroup: true,
      unreadCount: 4,
    ),
  ];

  // Getter to filter chats based on the selected tab
  List<ChatTileData> get filteredChats {
    switch (selectedTabIndex) {
      case 1: // Unread
        return dummyChats
            .where((chat) => chat.unreadCount != null && chat.unreadCount! > 0)
            .toList();
      case 2: // Groups
        return dummyChats.where((chat) => chat.isGroup == true).toList();
      case 0: // All
      default:
        return dummyChats;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chats = filteredChats;

    if (chats.isEmpty) {
      return const Center(
        child: Text(
          'No chats found',
          style: TextStyle(color: Colors.white38, fontSize: 14),
        ),
      );
    }

    return ScrollAware(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];

          return ChatTile(
            chat: chat,
            onTap: () {
              if (onChatSelected != null) {
                onChatSelected!(chat);
              }
            },
          );
        },
      ),
    );
  }
}