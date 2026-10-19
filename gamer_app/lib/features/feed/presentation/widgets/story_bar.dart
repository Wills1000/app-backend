import 'package:flutter/material.dart';
import 'story_avatar.dart';

class StoryBar extends StatelessWidget {
  const StoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: const [
          StoryAvatar(
            avatarUrl: 'https://placeholder.co/100',
            name: 'Your Story',
            isUser: true,
          ),
          StoryAvatar(
            avatarUrl: 'https://placeholder.co/100',
            name: 'QueenB',
          ),
          StoryAvatar(
            avatarUrl: 'https://placeholder.co/100',
            name: 'DaPrince',
          ),
          StoryAvatar(
            avatarUrl: 'https://placeholder.co/100',
            name: 'BeastMode',
          ),
          StoryAvatar(
            avatarUrl: 'https://placeholder.co/100',
            name: 'KingTobi',
          ),
        ],
      ),
    );
  }
}