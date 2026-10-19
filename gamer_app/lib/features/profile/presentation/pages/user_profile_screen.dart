import 'package:flutter/material.dart';
import '../widgets/user_profile_header.dart';
import '../widgets/stats_grid.dart';
import '../widgets/post_card.dart';
import 'package:gamer_app/core/widgets/app_background.dart';

class UserProfileScreen extends StatefulWidget {
  static const String routeName = '/user-profile';

  final String name;
  final String username;
  final String avatarUrl;

  const UserProfileScreen({
    super.key,
    this.name = 'KingTobi',
    this.username = 'kingtobi_pubg',
    this.avatarUrl = 'https://picsum.photos/200/200?random=99',
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  static const Color primaryRed = Color(0xFF970303);
  bool isGridView = true;

  final List<Map<String, String>> posts = [
    {'title': 'PUBG CLUTCH', 'views': '22.1K', 'image': 'https://picsum.photos/300/400?random=11'},
    {'title': 'SQUAD WIPEOUT', 'views': '18.4K', 'image': 'https://picsum.photos/300/400?random=12'},
    {'title': 'SNIPER GOD', 'views': '31.0K', 'image': 'https://picsum.photos/300/400?random=13'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090304),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          widget.name,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 22),
            onPressed: () {
              // Block / Report user options
            },
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                UserProfileHeader(
                  name: widget.name,
                  username: widget.username,
                  country: 'Nigeria',
                  bio: 'PUBG Mobile Competitive Player.\nTournaments & Escrow Matches.',
                  avatarUrl: widget.avatarUrl,
                  level: 38,
                  onChallenge: () {
                    // Open challenge/escrow modal
                  },
                ),
                const SizedBox(height: 20),

                const StatsGrid(
                  wins: 98,
                  losses: 14,
                  matches: 112,
                  winRate: '87%',
                  friends: 180,
                  following: 45,
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Posts (${posts.length})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(width: 32, height: 2, color: primaryRed),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.grid_view_rounded,
                            color: isGridView ? primaryRed : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () => setState(() => isGridView = true),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.favorite_border_rounded,
                            color: !isGridView ? primaryRed : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () => setState(() => isGridView = false),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostCard(
                      thumbnailUrl: post['image']!,
                      title: post['title']!,
                      views: post['views']!,
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}