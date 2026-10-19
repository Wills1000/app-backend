import 'package:flutter/material.dart';
import '../../models/payment_method_model.dart';

class PaymentMethodTile extends StatelessWidget {
  final PaymentMethodModel method;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  static const Color accentRed = Color(0xFFFF2233);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.white10,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Radio Indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? accentRed : Colors.white24,
                  width: isSelected ? 5 : 1.5,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Icon
            SizedBox(
              width: 22,
              height: 22,
              child: Center(child: method.icon),
            ),
            const SizedBox(width: 12),

            // Title
            Expanded(
              child: Text(
                method.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Optional Recommended Badge
            if (method.badgeText != null) ...[
              Text(
                method.badgeText!,
                style: const TextStyle(
                  color: accentRed,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
            ],

            // Optional Trailing Badge (Card Logos)
            if (method.trailingBadge != null) ...[
              method.trailingBadge!,
              const SizedBox(width: 6),
            ],

            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withOpacity(0.3),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}