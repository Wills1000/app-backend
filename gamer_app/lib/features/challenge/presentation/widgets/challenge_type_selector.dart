import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/challenge.dart';

class ChallengeTypeSelector extends StatelessWidget {
  final ChallengeType selectedType;
  final Function(ChallengeType) onTypeChanged;

  const ChallengeTypeSelector({
    Key? key,
    required this.selectedType,
    required this.onTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTypeChanged(ChallengeType.public),
              child: Container(
                decoration: BoxDecoration(
                  color: selectedType == ChallengeType.public ? AppColors.primaryRed : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Public',
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontWeight: selectedType == ChallengeType.public ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (selectedType == ChallengeType.public) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.check, size: 14, color: AppColors.textWhite),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTypeChanged(ChallengeType.private),
              child: Container(
                decoration: BoxDecoration(
                  color: selectedType == ChallengeType.private ? AppColors.primaryRed : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Private',
                    style: TextStyle(
                      color: selectedType == ChallengeType.private ? AppColors.textWhite : AppColors.textMuted,
                      fontWeight: selectedType == ChallengeType.private ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}