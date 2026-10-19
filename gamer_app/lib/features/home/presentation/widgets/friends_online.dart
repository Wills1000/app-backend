import 'package:flutter/material.dart';
import 'flat_card.dart';

class FriendsOnline extends StatelessWidget {
  const FriendsOnline({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> players = [
      {'name': 'DarkPhoenix', 'status': 'Online'},
      {'name': 'AceMaster', 'status': 'Online'},
      {'name': 'ShadowNinja', 'status': 'Online'},
      {'name': 'ZeroX', 'status': 'Offline'},
    ];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: players.length,
        itemBuilder: (context, index) {
          final p = players[index];
          final isOnline = p['status'] == 'Online';

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FlatCard(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                          radius: 18, backgroundColor: Colors.white24),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isOnline ? Colors.greenAccent : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1.5),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(p['name']!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      Text(p['status']!,
                          style: TextStyle(
                              color: isOnline
                                  ? Colors.greenAccent
                                  : Colors.white38,
                              fontSize: 9)),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}