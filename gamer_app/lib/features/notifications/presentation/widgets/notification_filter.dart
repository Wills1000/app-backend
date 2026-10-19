import 'package:flutter/material.dart';

class NotificationFilter extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onFilterSelected;

  const NotificationFilter({
    super.key,
    required this.selectedIndex,
    required this.onFilterSelected,
  });

  static const Color primaryRed = Color(0xFF970303);
  static const Color capsuleBg = Color(0xFF141416); // Outer capsule dark container

  final List<String> _filters = const ['All', 'Unread', 'Matches', 'System'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(4.0), // Outer padding inside capsule
      decoration: BoxDecoration(
        color: capsuleBg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: List.generate(_filters.length, (index) {
          final isSelected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onFilterSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10), // Correct
                decoration: BoxDecoration(
                  color: isSelected ? primaryRed : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: primaryRed.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  _filters[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}