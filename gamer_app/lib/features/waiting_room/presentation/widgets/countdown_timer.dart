import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CountdownTimerWidget extends StatelessWidget {
  final String timeString;

  const CountdownTimerWidget({Key? key, required this.timeString}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryRed.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text(
            'MATCH STARTING IN',
            style: TextStyle(color: AppColors.textMuted, fontSize: 10, letterSpacing: 0.8),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer_outlined, color: AppColors.primaryRed, size: 22),
              const SizedBox(width: 8),
              Text(
                timeString,
                style: const TextStyle(
                  color: AppColors.primaryRed,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Both players must be ready to start the match',
            style: TextStyle(color: AppColors.textMuted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}