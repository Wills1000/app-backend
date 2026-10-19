import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class WinnerSelector extends StatelessWidget {
  final String selectedWinnerId;
  final Function(String) onWinnerSelected;

  const WinnerSelector({
    Key? key,
    required this.selectedWinnerId,
    required this.onWinnerSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WHO WON THIS MATCH?',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        _buildOption(
          id: 'DaPrince',
          name: 'DaPrince',
          isYou: true,
          avatarUrl: 'https://i.pravatar.cc/150?img=11',
        ),
        const SizedBox(height: 10),
        _buildOption(
          id: 'qqgamerbeast',
          name: 'qqgamerbeast',
          isYou: false,
          avatarUrl: 'https://i.pravatar.cc/150?img=33',
        ),
      ],
    );
  }

  Widget _buildOption({
    required String id,
    required String name,
    required bool isYou,
    required String avatarUrl,
  }) {
    final isSelected = selectedWinnerId == id;

    return GestureDetector(
      onTap: () => onWinnerSelected(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF16161A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : Colors.white.withOpacity(0.08),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: name,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  children: [
                    if (isYou)
                      const TextSpan(
                        text: ' (You)',
                        style: TextStyle(
                          color: AppColors.primaryRed,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryRed : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primaryRed : Colors.grey[700]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}