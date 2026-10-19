import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/challenge_history.dart';

class ChallengeCard extends StatelessWidget {
  final ChallengeHistoryItem item;
  final VoidCallback? onTap;

  const ChallengeCard({Key? key, required this.item, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    if (item.result == 'Won') {
      statusColor = AppColors.greenSuccess;
    } else if (item.result == 'Lost') {
      statusColor = AppColors.primaryRed;
    } else {
      statusColor = AppColors.textMuted;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.sports_esports, color: AppColors.textWhite),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.gameTitle, style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(item.mode, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.monetization_on, color: AppColors.gold, size: 16),
                    const SizedBox(width: 4),
                    Text('${item.wager.toInt()}', style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const Divider(color: AppColors.cardBorder, height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('vs. ${item.opponentUsername}', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                Row(
                  children: [
                    Text(
                      item.result == 'Cancelled' ? 'Cancelled' : 'You ${item.result}',
                      style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    if (item.score != '-') ...[
                      const SizedBox(width: 8),
                      Text(item.score, style: const TextStyle(color: AppColors.textWhite, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ],
                ),
                Text(item.timeAgo, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}