import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StakeSelector extends StatelessWidget {
  final double currentWager;
  final Function(double) onWagerChanged;

  const StakeSelector({
    Key? key,
    required this.currentWager,
    required this.onWagerChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presets = [100.0, 500.0, 1000.0, 5000.0];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: presets.map((amount) {
            final isSelected = currentWager == amount;
            return GestureDetector(
              onTap: () => onWagerChanged(amount),
              child: Container(
                width: 70,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryRed.withOpacity(0.2) : AppColors.cardBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryRed : AppColors.cardBorder,
                  ),
                ),
                child: Center(
                  child: Text(
                    amount.toInt().toString(),
                    style: TextStyle(
                      color: isSelected ? AppColors.textWhite : AppColors.textMuted,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primaryRed,
            inactiveTrackColor: AppColors.cardBorder,
            thumbColor: AppColors.primaryRed,
            overlayColor: AppColors.primaryRed.withOpacity(0.2),
          ),
          child: Slider(
            value: currentWager.clamp(100.0, 10000.0),
            min: 100,
            max: 10000,
            onChanged: onWagerChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('100', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
            Text('10,000', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
          ],
        ),
      ],
    );
  }
}