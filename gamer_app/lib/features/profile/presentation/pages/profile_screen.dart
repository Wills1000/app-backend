import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/stats_grid.dart';
import '../widgets/post_card.dart';
import 'package:gamer_app/core/network/dio_client.dart';
import 'package:gamer_app/core/widgets/app_background.dart';
import 'package:gamer_app/features/auth/repositories/profile_repository.dart';
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
 
  final ProfileRepository _profileRepo = ProfileRepository(DioClient());
 
  Map<String, dynamic>? _me; // the signed-in user's data from the server
  bool _loading = true;
  String? _error;
 
  // Posts are still sample data for now
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
  void initState() {
    super.initState();
    _loadProfile();
  }
 
  // Loads the signed-in user's real details from the server
  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });
 
    try {
      final me = await _profileRepo.getMe();
      if (!mounted) return;
      setState(() {
        _me = me;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Something went wrong. Please try again.';
        _loading = false;
      });
    }
  }
 
  // --- small helpers for reading the server data safely ---
 
  Map<String, dynamic> get _profile {
    final p = _me?['profile'];
    return p is Map ? Map<String, dynamic>.from(p) : {};
  }
 
  Map<String, dynamic> get _counts {
    final c = _me?['counts'];
    return c is Map ? Map<String, dynamic>.from(c) : {};
  }
 
  int _asInt(dynamic v) {
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? 0;
  }
 
  String _text(dynamic v) => (v ?? '').toString().trim();
 
  String _flagFor(String country) {
    if (country.isEmpty) return '🌍';
    try {
      return CountryParser.tryParseCountryName(country)?.flagEmoji ?? '🌍';
    } catch (_) {
      return '🌍';
    }
  }
 
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
          child: _buildBody(),
        ),
      ),
    );
  }
 
  Widget _buildBody() {
    // First load: show a spinner
    if (_loading && _me == null) {
      return const Center(
        child: CircularProgressIndicator(color: primaryRed),
      );
    }
 
    // Could not load and nothing to show: error with a retry button
    if (_me == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, color: Colors.white38, size: 48),
              const SizedBox(height: 14),
              Text(
                _error ?? 'Could not load your profile.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 15),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _loadProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Try again',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }
 
    final profile = _profile;
    final counts = _counts;
 
    final username = _text(profile['username']);
    final fullName =
        '${_text(profile['firstName'])} ${_text(profile['lastName'])}'.trim();
    final country = _text(profile['country']);
    final bio = _text(profile['bio']);
    final avatar = _text(profile['avatarUrl']);
 
    final wins = _asInt(profile['matchesWon']);
    final losses = _asInt(profile['matchesLost']);
    final matches = _asInt(profile['matchesPlayed']);
    final winRate = matches == 0 ? 0 : (wins * 100 / matches).round();
 
    // Placeholder level: +1 for every 10 matches played
    final level = 1 + (matches ~/ 10);
 
    return RefreshIndicator(
      color: primaryRed,
      backgroundColor: const Color(0xff1B1B1B),
      onRefresh: _loadProfile,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
 
            // Header Section with side-by-side Edit Profile & Wallet buttons
            ProfileHeader(
              name: fullName.isEmpty ? username : fullName,
              username: username,
              country: country.isEmpty ? 'Not set' : country,
              flag: _flagFor(country),
              bio: bio.isEmpty ? 'No bio yet.' : bio,
              avatarUrl: avatar.isEmpty ? 'assets/avatars/ava1.jpg' : avatar,
              level: level,
              isVerified: _me?['isVerified'] == true,
              onEditProfile: () {
                // Navigate to edit_profile_screen.dart
              },
              onWalletTap: () {
                // Navigate to wallet flow or modal
              },
            ),
            const SizedBox(height: 20),
 
            // Stats Grid
            StatsGrid(
              wins: wins,
              losses: losses,
              matches: matches,
              winRate: '$winRate%',
              friends: _asInt(counts['friends']),
              following: _asInt(counts['following']),
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
    );
  }
}
 