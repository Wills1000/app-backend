import 'package:flutter/material.dart';

class RateInfoCard extends StatelessWidget {
  const RateInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Coin Rate',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 14),

        _buildInfoItem(
          title: 'Fixed Coin Value',
          subtitle: '1 Coin is always equal to \$0.10 USD. This value is fixed and cannot be changed.',
        ),
        const SizedBox(height: 12),

        _buildInfoItem(
          title: 'Real-time Exchange Rates',
          subtitle: 'Other currencies are updated in real-time based on global market rates.',
        ),
        const SizedBox(height: 12),

        _buildInfoItem(
          title: 'Secure & Transparent',
          subtitle: 'We use trusted financial data providers to ensure accuracy and transparency.',
        ),
        const SizedBox(height: 12),

        _buildInfoItem(
          title: 'Used For',
          subtitle: 'Deposits, withdrawals, challenges, and all transactions in the app.',
        ),
        const SizedBox(height: 16),

        // Support Callout Box
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF16161A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE50914).withOpacity(0.4)),
          ),
          child: Row(
            children: const [
              Icon(Icons.shield_outlined, color: Color(0xFFE50914), size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'If you have any questions about our coin or exchange rates, contact our support team.',
                  style: TextStyle(color: Colors.white70, fontSize: 10, height: 1.3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({required String title, required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFE50914).withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.shield_outlined, color: Color(0xFFE50914), size: 14),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white38, fontSize: 10, height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}