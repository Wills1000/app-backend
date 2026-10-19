import 'package:flutter/material.dart';
import 'escrow_locked_badge.dart';
import 'escrow_pending_badge.dart';
import 'escrow_released_badge.dart';

class EscrowCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status; // 'LOCKED', 'AWAITING', 'COMPLETED'
  final String yourStake;
  final String oppStake;
  final String totalEscrow;
  final VoidCallback onTap;

  const EscrowCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.yourStake,
    required this.oppStake,
    required this.totalEscrow,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF16161A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 52,
                  height: 52,
                  color: Colors.grey[900],
                  child: const Icon(Icons.sports_esports, color: Colors.white70, size: 28),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildBadge(),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: 'You: ',
                        style: const TextStyle(color: Colors.white54, fontSize: 11),
                        children: [
                          TextSpan(
                            text: '$yourStake  ',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: 'Opp: '),
                          TextSpan(
                            text: oppStake,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(Icons.chevron_right, color: Colors.white38, size: 18),
                  const SizedBox(height: 12),
                  Text(
                    totalEscrow,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    switch (status) {
      case 'LOCKED':
        return const EscrowLockedBadge();
      case 'AWAITING':
        return const EscrowPendingBadge();
      case 'COMPLETED':
        return const EscrowReleasedBadge();
      default:
        return const SizedBox.shrink();
    }
  }
}