import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class WaitingIndicator extends StatelessWidget {
  const WaitingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text('Searching...', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        SizedBox(height: 8),
        SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textMuted),
        ),
      ],
    );
  }
}