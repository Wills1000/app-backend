import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class PlayerCard extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final String country;
  final String gameId;
  final bool isReady;
  final bool isSearching;
  final bool isCurrentUser;

  const PlayerCard({
    Key? key,
    required this.username,
    required this.avatarUrl,
    required this.country,
    required this.gameId,
    this.isReady = false,
    this.isSearching = false,
    this.isCurrentUser = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isSearching) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.cardBg.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08), style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(Icons.person_outline, color: AppColors.textMuted, size: 28),
            ),
            const SizedBox(height: 12),
            const Text('Searching...', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            const SizedBox(height: 8),
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isReady ? const Color(0xFF00E676).withOpacity(0.3) : Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          // Avatar Stack with status ring
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isReady ? const Color(0xFF00E676) : Colors.amber,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isReady ? const Color(0xFF00E676) : Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isReady ? Icons.check : Icons.priority_high,
                    size: 10,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Username & Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  username,
                  style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.check_circle, color: Colors.redAccent, size: 14),
            ],
          ),
          const SizedBox(height: 2),

          // Country
          Text(
            '🇳🇬 $country',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
          const SizedBox(height: 6),

          // Ready / Not Ready Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isReady ? const Color(0xFF00E676) : Colors.amber,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                isReady ? 'Ready' : 'Not Ready',
                style: TextStyle(
                  color: isReady ? const Color(0xFF00E676) : Colors.amber,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Game ID Box with Copy Button
          Container(
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
          ),
        ],
      ),
    );
  }
}