import 'package:flutter/material.dart';

class CoinBreakdownCard extends StatelessWidget {
  final int cashCoins;
  final int bonusCoins;

  const CoinBreakdownCard({
    super.key,
    required this.cashCoins,
    required this.bonusCoins,
  });

  static const Color accentRed = Color(0xFFFF2233);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF121215),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'COINS BREAKDOWN',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Cash Coins Item
              Expanded(
                child: _buildItem(
                  icon: Icons.shield_outlined,
                  color: accentRed,
                  title: 'Cash Coins',
                  count: cashCoins,
                  subtext: '(Can be withdrawn)',
                  subtextColor: const Color(0xFF4EFE80),
                ),
              ),
              Container(width: 1, height: 38, color: Colors.white.withOpacity(0.08)),
              const SizedBox(width: 8),

              // Bonus Coins Item
              Expanded(
                child: _buildItem(
                  icon: Icons.card_giftcard_rounded,
                  color: const Color(0xFFFFB703),
                  title: 'Bonus Coins',
                  count: bonusCoins,
                  subtext: '(Play to convert)',
                  subtextColor: const Color(0xFFFFB703),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required Color color,
    required String title,
    required int count,
    required String subtext,
    required Color subtextColor,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.12),
            border: Border.all(color: color.withOpacity(0.4), width: 1),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.info_outline_rounded, color: Colors.white.withOpacity(0.4), size: 12),
                ],
              ),
              const SizedBox(height: 1),
              Text(
                '$count',
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                subtext,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: subtextColor, fontSize: 9, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}