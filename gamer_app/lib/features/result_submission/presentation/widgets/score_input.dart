import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ScoreInputWidget extends StatelessWidget {
  final TextEditingController yourScoreController;
  final TextEditingController opponentScoreController;

  const ScoreInputWidget({
    Key? key,
    required this.yourScoreController,
    required this.opponentScoreController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'ENTER FINAL SCORE',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Enter the final score of the match',
          style: TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildScoreBox('YOUR SCORE', yourScoreController),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'VS',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            _buildScoreBox('OPPONENT SCORE', opponentScoreController),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreBox(String label, TextEditingController controller) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 9, letterSpacing: 0.5),
        ),
        const SizedBox(height: 6),
        Material(
          color: const Color(0xFF16161A),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}