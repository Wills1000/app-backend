import 'package:flutter/material.dart';
import 'story_avatar.dart';
import '../pages/story_view_screen.dart';
import '../pages/create_status_screen.dart';

class OnlinePlayers extends StatefulWidget {
  const OnlinePlayers({super.key});

  @override
  State<OnlinePlayers> createState() => _OnlinePlayersState();
}

class _OnlinePlayersState extends State<OnlinePlayers> {
  final List<UserStatusModel> _players = [
    UserStatusModel(
      userId: '1',
      userName: 'DaPrince',
      avatarUrl: 'https://placeholder.co/100',
      statusImages: ['status_1', 'status_2', 'status_3'],
      viewedCount: 0,
      isOnline: true,
    ),
    UserStatusModel(
      userId: '2',
      userName: 'KingTobi',
      avatarUrl: 'https://placeholder.co/100',
      statusImages: ['status_1', 'status_2'],
      viewedCount: 0,
      isOnline: true,
    ),
    UserStatusModel(
      userId: '3',
      userName: 'Ghostzy',
      avatarUrl: 'https://placeholder.co/100',
      statusImages: ['status_1'],
      viewedCount: 0,
      isOnline: true,
    ),
  ];

  void _openStory(int clickedIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryViewScreen(
          allStatuses: _players,
          initialUserIndex: clickedIndex,
          onViewedUpdated: (userId, updatedViewedCount) {
            setState(() {
              final player = _players.firstWhere((p) => p.userId == userId);
              player.viewedCount = updatedViewedCount;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _players.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return StoryAvatar(
              avatarUrl: '',
              name: 'New Status',
              isNewChatButton: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateStatusScreen(),
                  ),
                );
              },
            );
          }

          final playerIndex = index - 1;
          final player = _players[playerIndex];

          return StoryAvatar(
            avatarUrl: player.avatarUrl,
            name: player.userName,
            isOnline: player.isOnline,
            statusCount: player.statusImages.length,
            viewedCount: player.viewedCount,
            onTap: () => _openStory(playerIndex),
          );
        },
      ),
    );
  }
}
