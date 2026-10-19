import 'package:flutter/material.dart';

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({Key? key}) : super(key: key);

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final TextEditingController _sendController = TextEditingController(text: '500');
  double usdAmount = 50.00;
  double ngnAmount = 7517.50;

  void _calculateConversion(String text) {
    final coins = double.tryParse(text) ?? 0;
    setState(() {
      usdAmount = coins * 0.10;
      ngnAmount = coins * 150.35;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // "You Send" Field
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF16161A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('You send', style: TextStyle(color: Colors.white54, fontSize: 11)),
                  Text('Balance: 5,450 Coins', style: TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFDF00), Color(0xFFD4AF37)],
                      ),
                    ),
                    child: const Center(
                      child: Text('G', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _sendController,
                      keyboardType: TextInputType.number,
                      onChanged: _calculateConversion,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Text('Coins', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Swap Icon Indicator
        Transform.translate(
          offset: const Offset(0, 0),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF16161A),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE50914).withOpacity(0.5)),
            ),
            child: const Icon(Icons.swap_vert, color: Color(0xFFE50914), size: 18),
          ),
        ),

        // "You Receive" USD
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF16161A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('You receive', style: TextStyle(color: Colors.white54, fontSize: 11)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const CircleAvatar(radius: 12, backgroundColor: Colors.blueAccent, child: Text('US', style: TextStyle(fontSize: 8, color: Colors.white))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      usdAmount.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Text('USD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // "Or Receive In" NGN
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF16161A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Or receive in', style: TextStyle(color: Colors.white54, fontSize: 11)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const CircleAvatar(radius: 12, backgroundColor: Colors.green, child: Text('NG', style: TextStyle(fontSize: 8, color: Colors.white))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      ngnAmount.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Text('NGN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Exchange Rate Summary
        const Text(
          '1 Coin = \$0.10 USD  •  1 USD = ₦150.35 NGN',
          style: TextStyle(color: Color(0xFFE50914), fontSize: 10, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 18),

        // Convert Now Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE50914),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: const Text(
              'Convert Now',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}