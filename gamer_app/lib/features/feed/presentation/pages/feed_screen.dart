import 'package:flutter/material.dart';
import '../widgets/feed_header.dart';
import '../widgets/feed_post.dart';
import '../widgets/feed_tabs.dart';
import '../widgets/post_input.dart';
import '../widgets/story_bar.dart';
import '../widgets/tournament_banner.dart';
import 'package:gamer_app/core/navigation/scroll_aware.dart';
import 'package:gamer_app/core/widgets/app_background.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  final List<FeedPostData> dummyPosts = const [
    FeedPostData(
      authorName: 'DaPrince',
      authorAvatar: 'https://placeholder.co/100',
      timeAgo: '2h ago',
      gameTag: 'Call of Duty Mobile',
      content: 'Insane 1v2 clutch to close the match! 💀 Who else loves ranked matches? 🔥',
      mediaUrl: 'https://placeholder.co/400x225',
      isVideo: true,
      videoDuration: '0:30',
      likes: 245,
      comments: 32,
      shares: 12,
      hasAchievement: true,
      winnerName: 'DaPrince',
      loserName: 'AlexKillz',
      reward: '₦5,000',
    ),
    FeedPostData(
      authorName: 'QueenB',
      authorAvatar: 'https://placeholder.co/100',
      timeAgo: '5h ago',
      gameTag: 'Free Fire',
      content: 'Booyah! Nothing feels better than a squad win with the team! 💜',
      mediaUrl: 'https://placeholder.co/400x225',
      likes: 198,
      comments: 24,
      shares: 8,
    ),
    FeedPostData(
      authorName: 'KingTobi',
      authorAvatar: 'https://placeholder.co/100',
      timeAgo: '4h ago',
      gameTag: 'PUBG Mobile',
      content: 'Winner Winner Chicken Dinner! 🍗🔥 Back to back wins today!',
      mediaUrl: 'https://placeholder.co/400x225',
      likes: 310,
      comments: 45,
      shares: 19,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: const Color(0xff090304),

  body: AppBackground(
    child: SafeArea(
      child: Column(
          children: [
            // Top Left Logo Header
            const FeedHeader(),

            // Scrollable Content
            Expanded(
  child: ScrollAware(
    child: ListView(
      padding: const EdgeInsets.only(top: 4, bottom: 16),
                children: [
                  const FeedTabs(),
                  const SizedBox(height: 12),
                  const StoryBar(),
                  const SizedBox(height: 8),
                  const PostInput(),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        FeedPost(post: dummyPosts[0]),
                        const TournamentBanner(
                          title: 'The Solo Showdown',
                          prize: '₦50,000',
                          timeAgo: '6h ago',
                        ),
                        FeedPost(post: dummyPosts[1]),
                        FeedPost(post: dummyPosts[2]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
           ),
          ],
        ),
      ),
  ),
    );
  }
}