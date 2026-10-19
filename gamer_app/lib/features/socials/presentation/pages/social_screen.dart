import 'package:flutter/material.dart';
import '../widgets/chat_list.dart';
import '../widgets/chat_tabs.dart';
import '../widgets/online_players.dart';
import '../widgets/social_header.dart';
import '../widgets/conversation_screen.dart';
import 'package:gamer_app/core/widgets/app_background.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  int _selectedTabIndex = 0;

  int get totalUnreadCount {
    return ChatList.dummyChats
        .where((chat) => chat.unreadCount != null && chat.unreadCount! > 0)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090304),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SocialHeader(),
              const SizedBox(height: 4),

              // Instantiated without 'const'
              OnlinePlayers(),
              const SizedBox(height: 8),

              ChatTabs(
                selectedIndex: _selectedTabIndex,
                unreadCount: totalUnreadCount,
                onTabChanged: (index) {
                  setState(() => _selectedTabIndex = index);
                },
              ),
              const SizedBox(height: 10),

              Expanded(
                child: ChatList(
                  selectedTabIndex: _selectedTabIndex,
                  onChatSelected: (chat) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationScreen(
                          userName: chat.name,
                          userAvatar: chat.avatarUrl,
                          gameTag: chat.gameTag,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}