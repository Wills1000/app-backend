import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

void showConfirmCancelDialog(BuildContext context, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.cardBorder)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.primaryRed, size: 48),
          const SizedBox(height: 12),
          const Text('Cancel Challenge?', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          const Text('Are you sure you want to cancel this challenge? This action cannot be undone.', style: TextStyle(color: AppColors.textMuted, fontSize: 12), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.cardBorder)),
                  child: const Text('No, Keep It', style: TextStyle(color: AppColors.textWhite, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed),
                  child: const Text('Yes, Cancel', style: TextStyle(color: AppColors.textWhite, fontSize: 12)),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}