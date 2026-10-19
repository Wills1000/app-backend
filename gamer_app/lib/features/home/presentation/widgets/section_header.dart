import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.showFilter = false,
    this.onSeeAll,
    this.onFilterSelected,
    this.filterGames = const [],
  });

  final String title;
  final bool showFilter;
  final VoidCallback? onSeeAll;
  final ValueChanged<String>? onFilterSelected;
  final List<String> filterGames;

  @override
  Widget build(BuildContext context) {
    return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),

      if (showFilter)
        PopupMenuButton<String>(
          color: const Color(0xff160B0E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: const Icon(
            Icons.tune_rounded,
            color: Colors.white,
          ),
          onSelected: (value) {
           onFilterSelected?.call(value);
          },
          itemBuilder: (context) => filterGames.map((game) {
            return PopupMenuItem<String>(
              value: game,
              child: Text(
                game,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
        )
      else
        GestureDetector(
          onTap: onSeeAll,
          child: const Row(
            children: [
              Text(
                "See All",
                style: TextStyle(
                  color: Color(0xffE50914),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Color(0xffE50914),
                size: 16,
              ),
            ],
          ),
        ),
    ],
  );
  }
}