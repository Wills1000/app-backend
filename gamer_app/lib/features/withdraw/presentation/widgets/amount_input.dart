import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInput extends StatelessWidget {
  final TextEditingController controller;
  final int maxCoins;
  final ValueChanged<String> onChanged;
  final Function(int) onSelectQuickCoins;

  const AmountInput({
    super.key,
    required this.controller,
    required this.maxCoins,
    required this.onChanged,
    required this.onSelectQuickCoins,
  });

  static const Color cardBg = Color(0xFF121215);
  static const Color accentRed = Color(0xFFFF2233);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Coins to Withdraw',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        // Text Field Input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: TextStyle(color: Colors.white24),
                  ),
                  onChanged: onChanged,
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  border: Border.all(color: accentRed, width: 1.2),
                ),
                child: const Center(
                  child: Icon(Icons.shield, color: accentRed, size: 10),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Quick Selector Chips
        Row(
          children: [
            _buildChip('100 G', () => onSelectQuickCoins(100)),
            const SizedBox(width: 8),
            _buildChip('500 G', () => onSelectQuickCoins(500)),
            const SizedBox(width: 8),
            _buildChip('1,000 G', () => onSelectQuickCoins(1000)),
            const SizedBox(width: 8),
            _buildChip('Max', () => onSelectQuickCoins(maxCoins)),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(String label, VoidCallback onTap) {
    final bool hasG = label.contains('G');
    final String text = hasG ? label.replaceAll(' G', '') : label;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (hasG) ...[
                    const TextSpan(text: ' '),
                    const TextSpan(
                      text: 'G',
                      style: TextStyle(
                        color: accentRed,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}