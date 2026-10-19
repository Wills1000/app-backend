import 'package:flutter/material.dart';

class ConnectionStatusWidget extends StatelessWidget {
  final bool isSecure;

  const ConnectionStatusWidget({Key? key, this.isSecure = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isSecure ? const Color(0xFF00E676) : Colors.amber;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isSecure ? Icons.shield_outlined : Icons.warning_amber_rounded,
          color: color,
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          isSecure ? 'Secure Connection' : 'Poor Connection',
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}