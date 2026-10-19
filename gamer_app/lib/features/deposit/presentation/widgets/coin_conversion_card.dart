import 'package:flutter/material.dart';

class CoinConversionCard extends StatelessWidget {
  final int calculatedCoins;
  final double rateNaira;
  final int rateCoins;

  const CoinConversionCard({
    super.key,
    required this.calculatedCoins,
    required this.rateNaira,
    required this.rateCoins,
  });

  static const Color cardBg = Color(0xFF121215);
  static const Color accentRed = Color(0xFFFF2233);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You will receive',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                _formatAmount(calculatedCoins),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              _buildCoinBadge(),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Rate: ${rateCoins} G = ₦${_formatAmount(rateNaira.toInt())}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinBadge() {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        border: Border.all(color: accentRed, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentRed.withOpacity(0.4),
            blurRadius: 6,
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.shield, color: accentRed, size: 12),
      ),
    );
  }

  String _formatAmount(int val) {
    return val.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }
}