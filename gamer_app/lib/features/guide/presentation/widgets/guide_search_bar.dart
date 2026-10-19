import 'package:flutter/material.dart';

class GuideSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const GuideSearchBar({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: Colors.white38, size: 20),
          hintText: 'Search guides, rules, disputes...',
          hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
          border: InputBorder.none,
        ),
      ),
    );
  }
}