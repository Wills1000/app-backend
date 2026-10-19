import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class LeaveMatchButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LeaveMatchButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white.withOpacity(0.2)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('LEAVE MATCH', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }
}