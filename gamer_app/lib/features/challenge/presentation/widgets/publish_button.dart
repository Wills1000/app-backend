import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PublishButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const PublishButton({
    Key? key,
    required this.onTap,
    this.label = 'Publish Challenge',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.verified_user_outlined, color: AppColors.textMuted, size: 14),
            SizedBox(width: 4),
            Text('Secure & Fair Play', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
          ],
        ),
      ],
    );
  }
}