import 'package:flutter/material.dart';

class TransactionFilterBar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const TransactionFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  // Color matching the UI in your reference image
  static const Color accentRed = Color(0xFFFF002B);
  static const Color barBackground = Color(0xFF16161A);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: barBackground,
        borderRadius: BorderRadius.circular(30), // Stadium capsule shape
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Row(
        children: categories.map((category) {
          final isSelected = category == selectedCategory;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(category),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? accentRed : Colors.transparent,
                  borderRadius: BorderRadius.circular(24), // Active red pill radius
                ),
                child: Center(
                  child: Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.45),
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}