import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ReadyButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ReadyButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text("I'M READY", style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }
}