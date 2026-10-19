import 'package:flutter/material.dart';

class PlayerAvatar extends StatelessWidget {
  final String avatarUrl;
  final bool isReady;
  final double radius;

  const PlayerAvatar({
    Key? key,
    required this.avatarUrl,
    this.isReady = false,
    this.radius = 26.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isReady ? const Color(0xFF00E676) : Colors.amber,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundImage: NetworkImage(avatarUrl),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            width: radius * 0.6,
            height: radius * 0.6,
            decoration: BoxDecoration(
              color: isReady ? const Color(0xFF00E676) : Colors.amber,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isReady ? Icons.check : Icons.priority_high,
              size: radius * 0.38,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}