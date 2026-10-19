// decline_button.dart
import 'package:flutter/material.dart';

class DeclineButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DeclineButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        side: BorderSide(color: Colors.white.withOpacity(0.15)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Decline', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }
}