import 'package:flutter/material.dart';

/// Data model representing a Live Stream Match item
class LiveMatchModel {
  final String gameTitle;
  final String streamThumbnailUrl;
  final String prizePool;
  final int viewerCount;
  final String player1Name;
  final String player1Avatar;
  final bool isPlayer1Verified;
  final String player2Name;
  final String player2Avatar;
  final bool isPlayer2Verified;

  const LiveMatchModel({
    required this.gameTitle,
    required this.streamThumbnailUrl,
    required this.prizePool,
    required this.viewerCount,
    required this.player1Name,
    required this.player1Avatar,
    this.isPlayer1Verified = true,
    required this.player2Name,
    required this.player2Avatar,
    this.isPlayer2Verified = true,
  });
}

class LiveTab extends StatelessWidget {
  const LiveTab({super.key});

  static const Color primaryRed = Color(0xFF970303);
  static const Color cardBg = Color(0xFF141416);

  // Mock live matches data
  final List<LiveMatchModel> _liveMatches = const [
    LiveMatchModel(
      gameTitle: 'COD Mobile',
      streamThumbnailUrl: 'https://picsum.photos/400/250?random=201',
      prizePool: '₦20,000',
      viewerCount: 324,
      player1Name: 'DaPrince',
      player1Avatar: 'https://i.pravatar.cc/100?img=11',
      player2Name: 'KingTobi',
      player2Avatar: 'https://i.pravatar.cc/100?img=12',
    ),
    LiveMatchModel(
      gameTitle: 'PUBG Mobile',
      streamThumbnailUrl: 'https://picsum.photos/400/250?random=202',
      prizePool: '₦15,000',
      viewerCount: 276,
      player1Name: 'SavageX',
      player1Avatar: 'https://i.pravatar.cc/100?img=13',
      player2Name: 'StrikerX',
      player2Avatar: 'https://i.pravatar.cc/100?img=14',
    ),
    LiveMatchModel(
      gameTitle: 'eFootball',
      streamThumbnailUrl: 'https://picsum.photos/400/250?random=203',
      prizePool: '₦5,000',
      viewerCount: 189,
      player1Name: 'FootyKing',
      player1Avatar: 'https://i.pravatar.cc/100?img=15',
      player2Name: 'CR7Junior',
      player2Avatar: 'https://i.pravatar.cc/100?img=16',
    ),
    LiveMatchModel(
      gameTitle: 'Free Fire',
      streamThumbnailUrl: 'https://picsum.photos/400/250?random=204',
      prizePool: '₦10,000',
      viewerCount: 512,
      player1Name: 'FireLord',
      player1Avatar: 'https://i.pravatar.cc/100?img=17',
      player2Name: 'TeamVortex',
      player2Avatar: 'https://i.pravatar.cc/100?img=18',
    ),
    LiveMatchModel(
      gameTitle: 'FC Mobile',
      streamThumbnailUrl: 'https://picsum.photos/400/250?random=205',
      prizePool: '₦8,000',
      viewerCount: 418,
      player1Name: 'StrikerX',
      player1Avatar: 'https://i.pravatar.cc/100?img=19',
      player2Name: 'MightyMan',
      player2Avatar: 'https://i.pravatar.cc/100?img=20',
    ),
    LiveMatchModel(
      gameTitle: 'GTA V',
      streamThumbnailUrl: 'https://picsum.photos/400/250?random=206',
      prizePool: '₦25,000',
      viewerCount: 156,
      player1Name: 'ViperX',
      player1Avatar: 'https://i.pravatar.cc/100?img=21',
      player2Name: 'GhostPlay',
      player2Avatar: 'https://i.pravatar.cc/100?img=22',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Return pure body view (2-column scrollable grid)
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: _liveMatches.length,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72, // Adjusted ratio to fit all stream metadata cleanly
      ),
      itemBuilder: (context, index) {
        final match = _liveMatches[index];
        return _buildLiveCard(context, match);
      },
    );
  }

  Widget _buildLiveCard(BuildContext context, LiveMatchModel match) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Stream Preview Banner with Overlays
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    match.streamThumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[900],
                      child: const Icon(Icons.live_tv, color: Colors.grey),
                    ),
                  ),
                ),
              ),

              // Top Left: LIVE Badge & Mute Icon
              Positioned(
                top: 6,
                left: 6,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.volume_off,
                        color: Colors.white70,
                        size: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // Top Right: Viewers Count Badge
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.visibility_outlined,
                        color: Colors.white,
                        size: 10,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${match.viewerCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. VS Matchup Avatars & Usernames Row
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      // Player 1 Avatar
                      CircleAvatar(
                        radius: 11,
                        backgroundImage: NetworkImage(match.player1Avatar),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        match.player1Name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (match.isPlayer1Verified) ...[
                        const SizedBox(width: 2),
                        const Icon(Icons.verified, color: Colors.greenAccent, size: 10),
                      ],

                      // VS Badge
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          'VS',
                          style: TextStyle(
                            color: primaryRed,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),

                      // Player 2 Username & Avatar
                      Text(
                        match.player2Name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (match.isPlayer2Verified) ...[
                        const SizedBox(width: 2),
                        const Icon(Icons.verified, color: Colors.blueAccent, size: 10),
                      ],
                      const SizedBox(width: 3),
                      CircleAvatar(
                        radius: 11,
                        backgroundImage: NetworkImage(match.player2Avatar),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // 3. Game Title & Prize Pool
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        match.gameTitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Prize: ',
                        style: const TextStyle(color: Colors.grey, fontSize: 9),
                        children: [
                          TextSpan(
                            text: match.prizePool,
                            style: const TextStyle(
                              color: Color(0xFF00E676),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 4. Watch Live Outlined Action Button
                SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Action to launch live stream spectator view
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: primaryRed, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    icon: const Icon(
                      Icons.sensors,
                      color: primaryRed,
                      size: 12,
                    ),
                    label: const Text(
                      'Watch Live',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}