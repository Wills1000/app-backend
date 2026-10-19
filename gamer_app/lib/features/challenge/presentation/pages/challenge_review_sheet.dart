import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/challenge_summary_card.dart';
import '../widgets/publish_button.dart';

void showChallengeReviewSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text('Review Challenge', style: TextStyle(color: AppColors.textWhite, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          const ChallengeSummaryCard(
            game: 'Call of Duty: Mobile',
            mode: 'Team Deathmatch',
            type: 'Public',
            region: 'North America',
            wager: 500,
            rules: ['Best of 3', 'No cheating / No hacks', 'Respectful play'],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Total Wager', style: TextStyle(color: AppColors.textWhite, fontSize: 14)),
              Text('🪙 500', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'By publishing this challenge, you agree to our Terms of Service and Fair Play Policy.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 11),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          PublishButton(
            onTap: () {
              Navigator.pop(context);
              _showPublishSuccessDialog(context);
            },
          ),
        ],
      ),
    ),
  );
}

void _showPublishSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AppColors.cardBorder)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 16),
          const Text('Challenge Published!', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Your challenge is now live.', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Got It', style: TextStyle(color: AppColors.textWhite)),
            ),
          )
        ],
      ),
    ),
  );
}