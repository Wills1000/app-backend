import 'package:flutter/material.dart';

class SupportHeader extends StatelessWidget {
  const SupportHeader({super.key});

  static const Color primaryRed = Color(0xFF970303);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryRed.withOpacity(0.3)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryRed.withOpacity(0.35),
            const Color(0xFF141416),
            const Color(0xFF0D0D0E),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primaryRed.withOpacity(0.15),
            blurRadius: 16,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'How can we help you?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "We're here to assist you",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Headset Support Avatar Illustration Icon
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryRed.withOpacity(0.2),
              border: Border.all(color: primaryRed.withOpacity(0.5)),
            ),
            child: const Icon(
              Icons.headset_mic_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
        ],
      ),
    );
  }
}