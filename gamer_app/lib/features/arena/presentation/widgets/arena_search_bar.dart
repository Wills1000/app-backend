import 'package:flutter/material.dart';

class ArenaSearchBar extends StatelessWidget {
  const ArenaSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xff18181A),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xff2A2A2E)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.white38, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: TextField(
                style: TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search challenges...',
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}