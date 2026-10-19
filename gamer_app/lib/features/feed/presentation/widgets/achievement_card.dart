import 'package:flutter/material.dart';

class AchievementCard extends StatelessWidget {
  final String winnerName;
  final String loserName;
  final String reward;
  final String timeAgo;

  const AchievementCard({
    super.key,
    required this.winnerName,
    required this.loserName,
    required this.reward,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff1A1A1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff2A2A2E)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xff2A2000),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Color(0xffFFB800),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12),
                    children: [
                      TextSpan(
                        text: winnerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: ' won a match',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'vs $loserName',
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                reward,
                style: const TextStyle(
                  color: Color(0xff00FF66),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                timeAgo,
                style: const TextStyle(color: Colors.white38, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}