import 'package:flutter/material.dart';

class TransactionSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const TransactionSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  static const Color cardBg = Color(0xFF121215);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        autofocus: true,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        cursorColor: const Color(0xFFFF2233),
        decoration: InputDecoration(
          hintText: 'Search by title, TXN ID, or opponent...',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.35),
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.white.withOpacity(0.4),
            size: 20,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: Colors.white.withOpacity(0.5),
                    size: 18,
                  ),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}