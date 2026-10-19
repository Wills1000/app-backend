import 'package:flutter/material.dart';

class EscrowBreakdownSheet extends StatelessWidget {
  const EscrowBreakdownSheet({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EscrowBreakdownSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF121214),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
                const Text('Breakdown', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF16161A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  Icon(Icons.savings, color: Color(0xFFE50914), size: 40),
                  SizedBox(height: 8),
                  Text('Total Escrow Amount', style: TextStyle(color: Colors.white54, fontSize: 11)),
                  SizedBox(height: 4),
                  Text('₦10,000', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Secured and protected', style: TextStyle(color: Colors.white38, fontSize: 10)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildRow('Your Stake', '₦5,000'),
            const SizedBox(height: 10),
            _buildRow('Opponent Stake', '₦5,000'),
            const SizedBox(height: 10),
            _buildRow('Platform Fee', '₦0'),
            const Divider(height: 24, color: Colors.white10),
            _buildRow('Total Escrow', '₦10,000', isTotal: true),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.white54, size: 16),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Funds are held safely in escrow. The winner will receive the total amount once the result is confirmed.',
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50914),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Got it', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isTotal ? const Color(0xFFE50914) : Colors.white70, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
        Text(value, style: TextStyle(color: isTotal ? const Color(0xFFE50914) : Colors.white, fontWeight: FontWeight.bold, fontSize: isTotal ? 15 : 13)),
      ],
    );
  }
}