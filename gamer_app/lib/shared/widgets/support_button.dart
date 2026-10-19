import 'package:flutter/material.dart';
import 'package:gamer_app/features/support/presentation/pages/support_screen.dart';

class SupportButton extends StatelessWidget {
  const SupportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.support_agent_outlined),
      onPressed: () {
        Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const SupportScreen(),
  ),
);
      },
    );
  }
}