import 'package:flutter/material.dart';

class PlayerStatusIndicator extends StatelessWidget {
  final bool isReady;

  const PlayerStatusIndicator({Key? key, required this.isReady}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isReady ? const Color(0xFF00E676) : Colors.amber;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          isReady ? 'Ready' : 'Not Ready',
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}