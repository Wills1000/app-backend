import 'widgets/header.dart';
import 'widgets/featured_banner.dart';
import 'widgets/friends_online.dart';
import 'widgets/popular_games.dart';
import 'widgets/trending_matches.dart';
import 'widgets/games_library.dart';
import 'widgets/section_header.dart';
import 'package:flutter/rendering.dart';
import 'package:gamer_app/core/navigation/nav_provider.dart';
import 'package:gamer_app/core/navigation/scroll_aware.dart';
import 'package:gamer_app/features/socials/presentation/pages/social_screen.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedCategoryIndex = 0;
  String _selectedFilter = "All";

final List<String> _filterGames = [
  "All",   
  "FFP",
  "Football", 
  "Battle Royale",
  "Fighting"
  "Racing"
  "Sport"
  "Strategy"
];

  // --- Banner Carousel Controller & State ---
  final PageController _bannerPageController = PageController();
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  final List<String> _categories = [
    'All',
    'FPS',
    'Football',
    'Battle Royale',
    'Racing',
    'More v'
  ];


  final List<Map<String, String>> _featuredBanners = [
    {
      'tag': 'FEATURED GAME',
      'title': 'CALL OF DUTY\nMOBILE',
      'desc': 'Team up. Fight hard.\nDominate the battlefield!',
     'img': 'assets/images/b3.jpg',
    },
    {
      'tag': 'NEW SEASON',
      'title': 'PUBG MOBILE\nVALHALLA',
      'desc': 'Explore new maps,\nweapons, and exclusive skins!',
      'img': 'assets/images/b1.jpg',
    },
    {
      'tag': 'TOURNAMENT LIVE',
      'title': 'eFOOTBALL 2026\nCHAMPIONS',
      'desc': r'Compete with top players\nfor $10,000 prize pool!',
      'img': 'assets/images/b2.jpg',
    },
    {
      'tag': 'SURVIVAL MODE',
      'title': 'FREE FIRE\nRAMPAGE',
      'desc': 'Survive till the end.\nLast man standing wins!',
      'img': 'assets/images/b11.jpg',
    },
    {
      'tag': 'RANKED SEASON',
      'title': 'APEX LEGENDS\nMOBILE',
      'desc': 'Climb the leaderboards\nand claim your rewards!',
      'img': 'assets/images/b7.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();

    _bannerTimer = Timer.periodic(
  const Duration(seconds: 5),
  (timer) {
    if (!_bannerPageController.hasClients) return;

    _currentBannerIndex++;

    if (_currentBannerIndex >= _featuredBanners.length) {
      _currentBannerIndex = 0;
    }

    _bannerPageController.animateToPage(
      _currentBannerIndex,
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeInOutQuart,
    );
  },
);
    // Pulsing animation for ambient background glows
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.35, end: 0.75).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  } 

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerPageController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090304), // Deep dark base
      body: Stack(
        children: [
          // --- Ambient Animated Glow Backdrops ---
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: -60,
                    right: -60,
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xffE50914)
                                .withOpacity(_glowAnimation.value * 0.4),
                            const Color(0xff970303)
                                .withOpacity(_glowAnimation.value * 0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 400,
                    left: -80,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xff970303)
                                .withOpacity(_glowAnimation.value * 0.35),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    right: -50,
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xffE50914)
                                .withOpacity(_glowAnimation.value * 0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Blur filter over ambient colors
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
            child: Container(color: Colors.transparent),
          ),

          // --- Main Scrollable Content ---
          SafeArea(
           child: ScrollAware(
  child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Header(),
                  const SizedBox(height: 20),
                 FeaturedBanner(
  banners: _featuredBanners,
  controller: _bannerPageController,
  currentIndex: _currentBannerIndex,
  onPageChanged: (index) { 
    setState(() {
      _currentBannerIndex = index;
    });
  },
),
                  const SizedBox(height: 20),
                  SectionHeader(
  title: 'Friends online',
  onSeeAll: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SocialScreen(),
      ),
    );
  },
),
const SizedBox(height: 12),
const FriendsOnline(),
const SizedBox(height: 25),

const SectionHeader(title: 'Popular Games'),
const SizedBox(height: 12),
const PopularGames(),
const SizedBox(height: 25),

const SectionHeader(title: 'Trending Matches'),
const SizedBox(height: 12),
const TrendingMatches(),
                  const SizedBox(height: 30),

                  // Games Library Grid under Recommended Players
                  SectionHeader(
  title: 'All Games Library',
  showFilter: true,
  filterGames: _filterGames,
  onFilterSelected: (value) {
    setState(() {
      _selectedFilter = value;
    });
  },
),
                  const SizedBox(height: 14),
                  const GamesLibrary(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }

}