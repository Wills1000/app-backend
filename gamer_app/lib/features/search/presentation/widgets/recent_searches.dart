import 'package:flutter/material.dart';

class RecentSearches extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String> onDelete;
  final VoidCallback onClearAll;
  final ValueChanged<String> onTap;

  const RecentSearches({
    Key? key,
    required this.items,
    required this.onDelete,
    required this.onClearAll,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Searches',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            GestureDetector(
              onTap: onClearAll,
              child: const Text(
                'Clear All',
                style: TextStyle(
                  color: Color(0xFFE50914),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () => onTap(item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16161A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.history, color: Color(0xFFE50914), size: 14),
                        const SizedBox(width: 6),
                        Text(
                          item,
                          style: const TextStyle(color: Colors.white, fontSize: 11),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => onDelete(item),
                          child: const Icon(Icons.close, color: Colors.white38, size: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}