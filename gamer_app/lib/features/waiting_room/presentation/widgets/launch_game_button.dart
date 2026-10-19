import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class LaunchGameButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LaunchGameButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('LAUNCH GAME', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }
}