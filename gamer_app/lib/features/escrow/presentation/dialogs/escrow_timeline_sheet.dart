import 'package:flutter/material.dart';

class EscrowTimelineSheet extends StatelessWidget {
  const EscrowTimelineSheet({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EscrowTimelineSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF121214),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
                const Text(
                  'Timeline',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildItem('Challenge Created', 'May 20, 2025 • 10:15 PM\nby COD_JohnyYT', Icons.adjust, true, true),
                  _buildItem('Opponent Accepted', 'May 20, 2025 • 10:20 PM\nby COD_Dark', Icons.adjust, true, true),
                  _buildItem('Funds Locked in Escrow', 'May 20, 2025 • 10:30 PM\n₦10,000 locked', Icons.lock, true, true, isHighlighted: true),
                  _buildItem('Match Started', 'Waiting...', Icons.sports_esports, false, false),
                  _buildItem('Result Submitted', 'Waiting for both players', Icons.mail_outline, false, false),
                  _buildItem('Winner Confirmed', 'Waiting for admin', Icons.verified_outlined, false, false),
                  _buildItem('Funds Released', 'Waiting...', Icons.lock_open, false, false, isLast: true),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'You will be notified at each stage of the escrow process.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String title, String subtitle, IconData icon, bool isDone, bool showCheck, {bool isHighlighted = false, bool isLast = false}) {
    final color = isHighlighted ? const Color(0xFFE50914) : (isDone ? Colors.white : Colors.white24);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isHighlighted ? const Color(0xFFE50914) : Colors.grey[900],
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 1.5),
                ),
                child: Icon(icon, size: 14, color: isHighlighted ? Colors.white : color),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 1.5, color: isDone ? Colors.white24 : Colors.white10),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: Colors.white, fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                ],
              ),
            ),
          ),
          if (showCheck)
            const Icon(Icons.check_circle, color: Color(0xFFE50914), size: 16),
        ],
      ),
    );
  }
}