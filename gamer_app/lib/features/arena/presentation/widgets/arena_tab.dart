import 'package:flutter/material.dart';

class ArenaTab extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const ArenaTab({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  final List<String> tabs = const [
    'Stakes',
    'Live',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xff141416),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xff2A2A2E)),
        ),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = selectedIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTabSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xffE50914)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.white54,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}