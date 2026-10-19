import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class VsIndicator extends StatelessWidget {
  const VsIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: const Text(
        'VS',
        style: TextStyle(
          color: AppColors.textWhite,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}