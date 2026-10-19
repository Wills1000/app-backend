import 'package:flutter/material.dart';
import 'dart:ui';

class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.selectedNavIndex,
    required this.onTap,
  });

  final int selectedNavIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final items = [
    {"icon": Icons.home_rounded, "label": "Home"},
    {"icon": Icons.emoji_events_rounded, "label": "Arena"},
    {"icon": Icons.dynamic_feed_rounded, "label": "Feed"},
    {"icon": Icons.people_alt_rounded, "label": "Social"},
    {"icon": Icons.person_outline_rounded, "label": "Profile"},
  ];

  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: ClipRRect(
  borderRadius: BorderRadius.circular(40),
  child: BackdropFilter(
    filter: ImageFilter.blur(
      sigmaX: 18,
      sigmaY: 18,
    ),
    child: Container(
        height: 72,
        decoration: BoxDecoration(
  color: const Color(0xff111111).withOpacity(.72),

  borderRadius: BorderRadius.circular(40),

  border: Border.all(
    color: Colors.white.withOpacity(.08),
    width: 1,
  ),

  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(.55),
      blurRadius: 30,
      offset: const Offset(0, 18),
    ),

    BoxShadow(
      color: const Color(0xff970303).withOpacity(.10),
      blurRadius: 40,
      spreadRadius: -10,
    ),
  ],
),
        child: Row(
          children: List.generate(items.length, (index) {
            final selected = selectedNavIndex == index;

            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(40),
                onTap: () => onTap(index),
                
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      height: 2.5,
                      width: selected ? 34 : 0,
                      decoration: BoxDecoration(
                        color: const Color(0xffE50914),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: selected
    ? [
        BoxShadow(
          color: const Color(0xffE50914).withOpacity(.35),
          blurRadius: 24,
          spreadRadius: -6,
          offset: const Offset(0, 14),
        ),
      ]
    : [],
                      ),
                    ),

                    const SizedBox(height: 8),

                    AnimatedPadding(
  duration: const Duration(milliseconds: 250),
  padding: EdgeInsets.only(top: selected ? 0 : 4),
  child: AnimatedContainer(
  duration: const Duration(milliseconds: 250),
  curve: Curves.easeOut,
  width: 40,
  height: 40,
  
  child: Center(
    child: AnimatedScale(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      scale: selected ? 1.22 : 1,
      child:
                      Icon(
                        items[index]["icon"] as IconData,
                        size: 25,
                        color: selected
                            ? const Color(0xffE50914)
                            : Colors.grey,
                      ),
                      ),
),
                    ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    ),
   ),
   ),
  );
  }
}