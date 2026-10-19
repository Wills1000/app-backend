import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final int level;
  final bool isOnline;

  const ProfileAvatar({
    super.key,
    required this.imageUrl,
    this.level = 42,
    this.isOnline = true,
  });

  static const Color primaryRed = Color(0xFF970303);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer Glowing Red Ring
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: primaryRed, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: primaryRed.withOpacity(0.5),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              backgroundColor: Colors.grey[900],
            ),
          ),
        ),

        // Online Indicator Dot
        if (isOnline)
          Positioned(
            top: 4,
            right: 8,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFF00FF66),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
            ),
          ),

        // Level Badge at bottom
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: primaryRed.withOpacity(0.6), width: 1),
            ),
            child: Text(
              'Lv. $level',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}