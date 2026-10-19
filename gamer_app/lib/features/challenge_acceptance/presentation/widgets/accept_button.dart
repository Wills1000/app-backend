// accept_button.dart
import 'package:flutter/material.dart';

class AcceptButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const AcceptButton({super.key, required this.onPressed, this.label = 'Accept Challenge'});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF2233),
        minimumSize: const Size(double.infinity, 48),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }
}