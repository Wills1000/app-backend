import 'package:flutter/material.dart';

class FeedTabs extends StatefulWidget {
  const FeedTabs({super.key});

  @override
  State<FeedTabs> createState() => _FeedTabsState();
}

class _FeedTabsState extends State<FeedTabs> {
  int selectedIndex = 0;
  final List<String> categories = ['For You', 'Following', 'Trending', 'Esports'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xff141416),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xff222226)),
        ),
        child: Row(
          children: List.generate(categories.length, (index) {
            final isSelected = selectedIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xffE50914) : Colors.transparent,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Text(
                    categories[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white54,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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