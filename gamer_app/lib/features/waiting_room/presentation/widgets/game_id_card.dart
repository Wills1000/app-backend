import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class GameIdCard extends StatelessWidget {
  final String gameId;

  const GameIdCard({Key? key, required this.gameId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('GAME ID / IGN', style: TextStyle(color: AppColors.textMuted, fontSize: 8)),
                Text(
                  gameId,
                  style: const TextStyle(color: AppColors.textWhite, fontSize: 11, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: gameId));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Game ID copied!'), duration: Duration(seconds: 1)),
              );
            },
            child: const Icon(Icons.copy_rounded, color: AppColors.textMuted, size: 14),
          ),
        ],
      ),
    );
  }
}