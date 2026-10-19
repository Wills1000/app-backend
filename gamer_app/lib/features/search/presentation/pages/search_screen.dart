import 'package:flutter/material.dart';
import 'package:gamer_app/core/widgets/app_background.dart';
import '../../data/models/game_search_model.dart';
import '../../data/models/player_search_model.dart';
import '../widgets/search_bar.dart';
import '../widgets/search_category_tabs.dart';
import '../widgets/recent_searches.dart';
import '../widgets/game_search_card.dart';
import '../widgets/player_search_card.dart';
import '../widgets/popular_searches.dart';

class SearchScreen extends StatefulWidget {
  final int initialTab;

  const SearchScreen({
    Key? key,
    this.initialTab = 0,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late int _selectedCategory; // 0: All, 1: Games, 2: Players

  List<String> recentSearches = [
    'Call of Duty Mobile',
    'qgamerbeast',
    'PUBG Mobile',
  ];

  final List<String> popularSearches = [
    'COD Mobile',
    'PUBG Mobile',
    'eFootball 2024',
    'Free Fire MAX',
  ];

  final List<GameSearchModel> popularGames = const [
    GameSearchModel(
      id: '1',
      title: 'Call of Duty Mobile',
      genre: 'FPS',
      imageUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=400',
    ),
    GameSearchModel(
      id: '2',
      title: 'PUBG Mobile',
      genre: 'Battle Royale',
      imageUrl: 'https://images.unsplash.com/photo-1538481199705-c710c4e965fc?q=80&w=400',
    ),
    GameSearchModel(
      id: '3',
      title: 'eFootball',
      genre: 'Sports',
      imageUrl: 'https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=400',
    ),
    GameSearchModel(
      id: '4',
      title: 'Free Fire MAX',
      genre: 'Battle Royale',
      imageUrl: 'https://images.unsplash.com/photo-1560253023-3ec5d502959f?q=80&w=400',
    ),
  ];

  final List<PlayerSearchModel> suggestedPlayers = const [
    PlayerSearchModel(
      id: '1',
      username: 'qgamerbeast',
      isVerified: true,
      winRate: 78,
      matchesCount: 124,
      favoriteGame: 'Call of Duty Mobile',
      avatarUrl: 'https://i.pravatar.cc/150?img=11',
      isOnline: true,
    ),
    PlayerSearchModel(
      id: '2',
      username: 'NoMercy',
      isVerified: true,
      winRate: 65,
      matchesCount: 98,
      favoriteGame: 'PUBG Mobile',
      avatarUrl: 'https://i.pravatar.cc/150?img=33',
      isOnline: true,
    ),
    PlayerSearchModel(
      id: '3',
      username: 'SoccerKing10',
      isVerified: true,
      winRate: 82,
      matchesCount: 210,
      favoriteGame: 'eFootball 2024',
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
      isOnline: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                // Header Title
                const Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                const Text(
                  'Find games, players and more',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
                const SizedBox(height: 16),

                // Search Bar Widget
                CustomSearchBar(
                  controller: _searchController,
                  onChanged: (val) => setState(() {}),
                  onClear: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  onFilterTap: () {},
                ),
                const SizedBox(height: 14),

                // Category Selector Tabs Widget
                SearchCategoryTabs(
                  selectedIndex: _selectedCategory,
                  onTabSelected: (index) => setState(() => _selectedCategory = index),
                ),
                const SizedBox(height: 16),

                // Content Body List
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // Recent Searches
                      RecentSearches(
                        items: recentSearches,
                        onDelete: (item) => setState(() => recentSearches.remove(item)),
                        onClearAll: () => setState(() => recentSearches.clear()),
                        onTap: (item) {
                          _searchController.text = item;
                          setState(() {});
                        },
                      ),
                      if (recentSearches.isNotEmpty) const SizedBox(height: 20),

                      // Popular Games Horizontal List
                      if (_selectedCategory == 0 || _selectedCategory == 1) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Popular Games',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'See All',
                              style: TextStyle(
                                color: Color(0xFFE50914),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 160,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: popularGames.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              return GameSearchCard(
                                game: popularGames[index],
                                onTap: () {},
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Players You May Know Vertical List
                      if (_selectedCategory == 0 || _selectedCategory == 2) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Players you may know',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'See All',
                              style: TextStyle(
                                color: Color(0xFFE50914),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: suggestedPlayers.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            return PlayerSearchCard(
                              player: suggestedPlayers[index],
                              onAddTap: () {},
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Popular Searches Tags Widget
                      PopularSearches(
                        tags: popularSearches,
                        onTap: (tag) {
                          _searchController.text = tag;
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}