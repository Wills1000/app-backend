import 'package:flutter/material.dart';

class StakeInfoCard extends StatelessWidget {
  final int playerStake;
  final int fee;
  final int potentialWin;

  const StakeInfoCard({
    super.key,
    required this.playerStake,
    required this.fee,
    required this.potentialWin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          _buildRow('Player Stake', '$playerStake', isCoin: true),
          const SizedBox(height: 8),
          _buildRow('You will pay', '$fee', isCoin: true),
          const SizedBox(height: 8),
          _buildRow('Your potential win', '$potentialWin', isCoin: true, isHighlight: true),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isCoin = false, bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isHighlight ? const Color(0xFF00E676) : Colors.white.withOpacity(0.6),
            fontSize: 12,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Row(
          children: [
            if (isCoin) ...[
              Container(
                width: 13,
                height: 13,
                decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                child: const Center(
                  child: Text('G', style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              value,
              style: TextStyle(
                color: isHighlight ? const Color(0xFF00E676) : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}