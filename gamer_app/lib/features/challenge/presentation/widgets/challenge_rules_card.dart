import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ChallengeSummaryCard extends StatelessWidget {
  final String game;
  final String mode;
  final String type;
  final String region;
  final double wager;
  final List<String> rules;

  const ChallengeSummaryCard({
    Key? key,
    required this.game,
    required this.mode,
    required this.type,
    required this.region,
    required this.wager,
    required this.rules,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          _RowItem(label: 'Game', value: game),
          _RowItem(label: 'Mode', value: mode),
          _RowItem(label: 'Challenge Type', value: type),
          _RowItem(label: 'Region', value: region),
          _RowItem(label: 'Wager', value: '🪙 ${wager.toInt()}'),
          const Divider(color: AppColors.cardBorder, height: 20),
          CrossRulesView(rules: rules),
        ],
      ),
    );
  }
}

class CrossRulesView extends StatelessWidget {
  final List<String> rules;
  const CrossRulesView({Key? key, required this.rules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rules.map((r) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: AppColors.greenSuccess, size: 16),
            const SizedBox(width: 8),
            Text(r, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
      )).toList(),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String label;
  final String value;
  const _RowItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
          Text(value, style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}