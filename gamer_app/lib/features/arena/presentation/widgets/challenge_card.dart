import 'package:flutter/material.dart';
import 'package:gamer_app/features/challenge/presentation/pages/challenge_details_screen.dart';

enum ChallengeStatus { lookingForOpponent, live, accepted }

class ChallengeCardData {
  final String gameTitle;
  final String format;
  final String stake;
  final String hostName;
  final String gameImage;
  final String hostAvatar;
  final ChallengeStatus status;
  final String? viewersCount;
  final String? countdownTime;

  const ChallengeCardData({
    required this.gameTitle,
    required this.format,
    required this.stake,
    required this.hostName,
    required this.gameImage,
    required this.hostAvatar,
    required this.status,
    this.viewersCount,
    this.countdownTime,
  });
}

class ChallengeCard extends StatelessWidget {
  final ChallengeCardData challenge;

  const ChallengeCard({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xff141416),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xff222226)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Vertical Poster Container (3:4 aspect ratio fit)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  challenge.gameImage,
                  width: 54,
                  height: 76,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 54,
                    height: 76,
                    color: const Color(0xff222226),
                    child: const Icon(Icons.sports_esports, color: Colors.white38, size: 28),
                  ),
                ),
              ),
              if (challenge.status == ChallengeStatus.live)
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xffE50914),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),

          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Game Title
                Text(
                  challenge.gameTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),

                // Stake Amount
                Text(
                  challenge.stake,
                  style: const TextStyle(
                    color: Color(0xff00FF66),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                // Host Profile Avatar + Host Name
                Row(
                  children: [
                    CircleAvatar(
                      radius: 8,
                      backgroundImage: NetworkImage(challenge.hostAvatar),
                      backgroundColor: const Color(0xff222226),
                      child: const Icon(Icons.person, size: 10, color: Colors.white38),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Host: ${challenge.hostName}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Right Column: Format above Action Button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                challenge.format,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildCompactStatusAction(context, challenge),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatusAction(
  BuildContext context,
  ChallengeCardData challenge,
) {
  switch (challenge.status) {
    case ChallengeStatus.lookingForOpponent:
    case ChallengeStatus.lookingForOpponent:
  return ElevatedButton(
  onPressed: () {
    print('VIEW BUTTON PRESSED');
  },
  child: const Text('VIEW'),
);

      case ChallengeStatus.live:
        return SizedBox(
          height: 30,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffE50914),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Watch',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );

      case ChallengeStatus.accepted:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xff2A2000),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_outlined, color: Color(0xffFFB800), size: 12),
              const SizedBox(width: 4),
              Text(
                challenge.countdownTime ?? 'Soon',
                style: const TextStyle(
                  color: Color(0xffFFB800),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
    }
  }
}