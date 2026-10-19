import 'package:flutter/material.dart';

class ChatTabs extends StatelessWidget {
  final int selectedIndex;
  final int unreadCount;
  final Function(int) onTabChanged;

  const ChatTabs({
    super.key,
    required this.selectedIndex,
    required this.unreadCount,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tabs = [
      {'label': 'All', 'badge': null},
      {
        'label': 'Unread',
        'badge': unreadCount > 0 ? '$unreadCount' : null,
      },
      {'label': 'Groups', 'badge': null},
      {'label': 'Favourites', 'badge': null},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xff16161A), // Dark capsule outer container
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          final tab = tabs[index];

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xffE50914) : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tab['label'],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white54,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    if (tab['badge'] != null) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : const Color(0xffE50914),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          tab['badge'],
                          style: TextStyle(
                            color: isSelected ? const Color(0xffE50914) : Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}