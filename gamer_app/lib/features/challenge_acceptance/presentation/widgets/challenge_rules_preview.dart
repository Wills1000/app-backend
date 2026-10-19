import 'package:flutter/material.dart';

class ChallengeRulesPreview extends StatelessWidget {
  final List<String> rules;

  const ChallengeRulesPreview({
    super.key,
    this.rules = const ['No cheating / No hacks', 'Respect fair play', 'No toxic behavior'],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rules.map((rule) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF00E676), size: 16),
              const SizedBox(width: 8),
              Text(
                rule,
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}