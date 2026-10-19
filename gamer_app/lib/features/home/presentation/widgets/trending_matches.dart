import 'package:flutter/material.dart';
import 'flat_card.dart';

class TrendingMatches extends StatelessWidget {
  const TrendingMatches({super.key});

  @override
  Widget build(BuildContext context) {
   return Row(
      children: [
        Expanded(
            child: _buildMatchCard(
                'COD Mobile', '1v1', 'GhostX', 'Hunter99', '2/2', '500', '15:30')),
        const SizedBox(width: 12),
        Expanded(
            child: _buildMatchCard('PUBG Mobile', 'Squad', 'SniperGod',
                'NightWolf', '4/4', '1,000', '22:45')),
      ],
    );
  }

  Widget _buildMatchCard(
    String game,
    String type,
    String p1,
    String p2,
    String players,
    String prize,
    String time,
  ) {
    return FlatCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xffE50914).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(game,
                    style: const TextStyle(
                        color: Color(0xffFF4D4D),
                        fontSize: 9,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(type,
                    style: const TextStyle(color: Colors.white70, fontSize: 9)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const CircleAvatar(
                      radius: 16, backgroundColor: Colors.white24),
                  const SizedBox(height: 4),
                  Text(p1,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 11)),
                ],
              ),
              const Text('VS',
                  style: TextStyle(
                      color: Color(0xffE50914),
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              Column(
                children: [
                  const CircleAvatar(
                      radius: 16, backgroundColor: Colors.white24),
                  const SizedBox(height: 4),
                  Text(p2,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.group, color: Colors.white54, size: 12),
                  const SizedBox(width: 2),
                  Text(players,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 10)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 12),
                  const SizedBox(width: 2),
                  Text(prize,
                      style: const TextStyle(
                          color: Color(0xffFF4D4D),
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Starts in',
                      style: TextStyle(color: Colors.white38, fontSize: 9)),
                  Text(time,
                      style: const TextStyle(
                          color: Color(0xffFF4D4D),
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffE50914),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Join Match',
                    style: TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}