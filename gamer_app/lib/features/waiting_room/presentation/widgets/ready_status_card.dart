import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ReadyStatusCard extends StatelessWidget {
  final bool isBothReady;

  const ReadyStatusCard({Key? key, required this.isBothReady}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isBothReady) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF00E676).withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00E676).withOpacity(0.4)),
      ),
      child: Column(
        children: const [
          Icon(Icons.check_circle_outline, color: Color(0xFF00E676), size: 36),
          SizedBox(height: 8),
          Text(
            'BOTH PLAYERS ARE READY!',
            style: TextStyle(
              color: Color(0xFF00E676),
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Match will start automatically',
            style: TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}