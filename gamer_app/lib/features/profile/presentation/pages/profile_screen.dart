import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/stats_grid.dart';
import '../widgets/post_card.dart';
import 'package:gamer_app/core/widgets/app_background.dart';
import 'package:gamer_app/features/settings/presentation/pages/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color primaryRed = Color(0xFF970303);
  bool isGridView = true;

  final List<Map<String, String>> posts = [
    {'title': '', 'views': '12.4K', 'image': 'https://picsum.photos/300/400?random=1'},
    {'title': 'TOURNAMENT\nCHAMPION', 'views': '8.7K', 'image': 'https://picsum.photos/300/400?random=2'},
    {'title': 'INSANE\nSNIPER SHOT', 'views': '15.2K', 'image': 'https://picsum.photos/300/400?random=3'},
    {'title': '1v4\nCLUTCH', 'views': '9.1K', 'image': 'https://picsum.photos/300/400?random=4'},
    {'title': 'VICTORY\nROYALE', 'views': '7.3K', 'image': 'https://picsum.photos/300/400?random=5'},
    {'title': 'TOURNAMENT\nHIGHLIGHTS', 'views': '6.6K', 'image': 'https://picsum.photos/300/400?random=6'},
    {'title': '', 'views': '5.2K', 'image': 'https://picsum.photos/300/400?random=7'},
    {'title': '', 'views': '4.1K', 'image': 'https://picsum.photos/300/400?random=8'},
    {'title': '', 'views': '6.9K', 'image': 'https://picsum.photos/300/400?random=9'},
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
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 22),
            onPressed: () {
              Navigator.pushNamed(
                context,
                SettingsScreen.routeName,
              );
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

                // Header Section with side-by-side Edit Profile & Wallet buttons
                ProfileHeader(
                  name: 'Princewill',
                  username: 'godkiller09',
                  country: 'Nigeria',
                  bio: 'Gamer. Competitor. Winner.\nI don\'t play for fun, I play for victory.\nAlways improving. Always grinding.',
                  avatarUrl: 'https://picsum.photos/200/200',
                  level: 42,
                  onEditProfile: () {
                    // Navigate to edit_profile_screen.dart
                  },
                  onWalletTap: () {
                    // Navigate to wallet flow or modal
                  },
                ),
                const SizedBox(height: 20),

                // Stats Grid
                const StatsGrid(
                  wins: 124,
                  losses: 21,
                  matches: 145,
                  winRate: '86%',
                  friends: 245,
                  following: 78,
                ),
                const SizedBox(height: 20),

                // Posts Section Header
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
                            Icons.favorite_border_rounded, // Changed to Favorites icon
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

                // Posts Grid
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