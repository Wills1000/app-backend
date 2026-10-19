import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class GameSelector extends StatelessWidget {
  final String selectedGame;
  final String selectedGameImage;
  final String selectedMode;
  final Function(String) onSelect;

  const GameSelector({
    Key? key,
    required this.selectedGame,
    required this.selectedGameImage,
    required this.selectedMode,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Game Search Input
        TextField(
          style: const TextStyle(color: AppColors.textWhite, fontSize: 14),
          onChanged: (val) {
            if (val.trim().isNotEmpty) {
              onSelect(val.trim());
            }
          },
          decoration: InputDecoration(
            hintText: 'Search games...',
            hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
            filled: true,
            fillColor: AppColors.cardBg.withOpacity(0.6),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryRed),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Single Full-Width Selected Game Banner
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryRed, width: 1.5),
            image: DecorationImage(
              image: AssetImage(selectedGameImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Dark Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.85),
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.85),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),

              // Banner Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedGame.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedMode,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryRed,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, size: 14, color: AppColors.textWhite),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}