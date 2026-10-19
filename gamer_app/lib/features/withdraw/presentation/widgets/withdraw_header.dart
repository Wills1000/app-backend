import 'package:flutter/material.dart';

class WithdrawHeader extends StatelessWidget {
  final int availableCoins;
  final double ratePerCoin;

  const WithdrawHeader({
    super.key,
    required this.availableCoins,
    required this.ratePerCoin,
  });

  static const Color accentRed = Color(0xFFFF2233);
  static const Color cardBg = Color(0xFF121215);

  @override
  Widget build(BuildContext context) {
    final double totalNaira = availableCoins * ratePerCoin;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentRed.withOpacity(0.3), width: 1),
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.5,
          colors: [
            accentRed.withOpacity(0.18),
            cardBg,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Cash Coins',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                _formatAmount(availableCoins),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              _buildCoinBadge(),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '≈ ₦${_formatDecimal(totalNaira)}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinBadge() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        border: Border.all(color: accentRed, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentRed.withOpacity(0.5),
            blurRadius: 8,
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.shield, color: accentRed, size: 13),
      ),
    );
  }

  String _formatAmount(int val) {
    return val.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  String _formatDecimal(double val) {
    return val.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}