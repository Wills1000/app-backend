import 'package:flutter/material.dart';

class ChatSearch extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const ChatSearch({
    super.key,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xff141416),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xff222226)),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: const InputDecoration(
            hintText: 'Search chats or gamers...',
            hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
            prefixIcon: Icon(Icons.search, color: Colors.white38, size: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }
}