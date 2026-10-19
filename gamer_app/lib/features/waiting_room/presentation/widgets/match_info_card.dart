import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MatchInfoCard extends StatelessWidget {
  final String totalStake;
  final String entryFee;
  final String potentialWin;

  const MatchInfoCard({
    Key? key,
    this.totalStake = '₦10,000',
    this.entryFee = '₦5,000',
    this.potentialWin = '₦9,000',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildColumn('TOTAL STAKE', totalStake, AppColors.textWhite),
          Container(height: 28, width: 1, color: Colors.white.withOpacity(0.1)),
          _buildColumn('ENTRY FEE', entryFee, AppColors.textWhite),
          Container(height: 28, width: 1, color: Colors.white.withOpacity(0.1)),
          _buildColumn('POTENTIAL WIN', potentialWin, const Color(0xFF00E676)),
        ],
      ),
    );
  }

  Widget _buildColumn(String label, String amount, Color amountColor) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: amountColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}