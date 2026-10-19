import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RegionSelector extends StatelessWidget {
  final String userRegion; // Fixed user signup region

  const RegionSelector({
    Key? key,
    required this.userRegion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.public, color: AppColors.textMuted, size: 18),
              const SizedBox(width: 8),
              Text(
                userRegion,
                style: const TextStyle(color: AppColors.textWhite, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Icon(Icons.lock, color: AppColors.textMuted, size: 16),
        ],
      ),
    );
  }
}