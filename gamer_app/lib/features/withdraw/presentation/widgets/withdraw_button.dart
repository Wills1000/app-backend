import 'package:flutter/material.dart';

class WithdrawButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const WithdrawButton({
    super.key,
    required this.onPressed,
    this.label = 'Continue',
  });

  static const Color accentRed = Color(0xFFFF2233);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: accentRed,
          disabledBackgroundColor: accentRed.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
          shadowColor: accentRed.withOpacity(0.4),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}