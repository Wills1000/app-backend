import 'package:flutter/material.dart';
import 'package:gamer_app/features/challenge/presentation/pages/challenge_details_screen.dart';

/// Data model representing a Stake Challenge item
class StakeModel {
  final String gameTitle;
  final String imageUrl;
  final String amount;
  final String hostName;
  final bool isHostVerified;
  final String modeTag; // e.g., '1v1', '2v2', 'Squad'
  final String waitingCount; // e.g., '1/2', '3/4'
  final String region; // e.g., 'Nigeria'
  final String rankOrMode; // e.g., 'Gold', 'TPP', 'Legendary'
  final String timeAgo;

  const StakeModel({
    required this.gameTitle,
    required this.imageUrl,
    required this.amount,
    required this.hostName,
    this.isHostVerified = true,
    required this.modeTag,
    required this.waitingCount,
    this.region = 'Nigeria',
    required this.rankOrMode,
    required this.timeAgo,
  });
}

class StakesTab extends StatelessWidget {
  const StakesTab({super.key});

  static const Color primaryRed = Color(0xffE50914);
  static const Color cardBg = Color(0xFF141416); // Matches dark Arena card background

  // Mock stakes data
  final List<StakeModel> _stakesList = const [
    StakeModel(
      gameTitle: 'COD Mobile',
      imageUrl: 'assets/images/cod1.jpg',
      amount: '₦10,000',
      hostName: 'DaPrince',
      modeTag: '1v1',
      waitingCount: '1/2',
      rankOrMode: 'Diamond+',
      timeAgo: '2m ago',
    ),
    StakeModel(
      gameTitle: 'eFootball',
      imageUrl: 'assets/images/cod2.jpg',
      amount: '₦5,000',
      hostName: 'KingTobi',
      modeTag: '1v1',
      waitingCount: '1/2',
      rankOrMode: 'Gold',
      timeAgo: '5m ago',
    ),
    StakeModel(
      gameTitle: 'PUBG Mobile',
      imageUrl: 'assets/images/cod3.jpg',
      amount: '₦20,000',
      hostName: 'SavageX',
      modeTag: '2v2',
      waitingCount: '3/4',
      rankOrMode: 'TPP',
      timeAgo: '8m ago',
    ),
    StakeModel(
      gameTitle: 'Free Fire',
      imageUrl: 'assets/images/cod4.jpg',
      amount: '₦3,000',
      hostName: 'FireLord',
      modeTag: 'Squad',
      waitingCount: '2/4',
      rankOrMode: 'Squad',
      timeAgo: '12m ago',
    ),
    StakeModel(
      gameTitle: 'FC Mobile',
      imageUrl: 'https://picsum.photos/200/200?random=105',
      amount: '₦15,000',
      hostName: 'StrikerX',
      modeTag: '1v1',
      waitingCount: '1/2',
      rankOrMode: 'Legendary',
      timeAgo: '15m ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Pure body widget only (No Scaffold, Header, Search Bar, or TabBar)
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: _stakesList.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final stake = _stakesList[index];
        return _buildStakeCard(context, stake);
      },
    );
  }

  Widget _buildStakeCard(BuildContext context, StakeModel stake) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Game Cover Image Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 84,
              height: 84,
              color: Colors.grey[900],
              child: Image.network(
                stake.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.sports_esports,
                  color: Colors.grey,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 2. Middle Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mode Badge & Game Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        stake.modeTag,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        stake.gameTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Stake Amount (Naira)
                Text(
                  stake.amount,
                  style: const TextStyle(
                    color: Color(0xFF00E676), // Bright Arena Green
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),

                // Host Name with Verified Badge
                Row(
                  children: [
                    Text(
                      'Host: ${stake.hostName}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    if (stake.isHostVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        color: primaryRed,
                        size: 14,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),

                // Bottom Meta Line (Country • Mode • Time)
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.language,
                        color: Colors.grey,
                        size: 11,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        stake.region,
                        style: const TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      const Text(
                        '  •  ',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      Text(
                        stake.rankOrMode,
                        style: const TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      const Text(
                        '  •  ',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      Text(
                        stake.timeAgo,
                        style: const TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // 3. Right Side Column (Players Waiting Indicator & Accept Button)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Players Waiting Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.people_alt_outlined,
                      color: Colors.white70,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stake.waitingCount,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'waiting',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Accept Stake Action Button
              SizedBox(
                height: 34,
                child: ElevatedButton(
                  onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const ChallengeDetailsScreen(),
    ),
  );
},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffE50914),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'VIEW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}