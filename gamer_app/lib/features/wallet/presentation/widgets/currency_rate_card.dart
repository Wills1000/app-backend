import 'package:flutter/material.dart';

class CurrencyRateCard extends StatelessWidget {
  const CurrencyRateCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE50914).withOpacity(0.35), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE50914).withOpacity(0.08),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          // 3D Pedestal and Coin
          Expanded(
            flex: 4,
            child: SizedBox(
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: 8,
                    child: Container(
                      width: 76,
                      height: 22,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE50914).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFE50914),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 68,
                    height: 68,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFDF00), Color(0xFFD4AF37)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amberAccent,
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'G',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Rate Details
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '1 Coin\n= ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                      ),
                      TextSpan(
                        text: '\$0.10',
                        style: TextStyle(
                          color: Color(0xFFE50914),
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'USD',
                  style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Text(
                      'Fixed Rate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.verified, color: Colors.greenAccent, size: 14),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'This rate is fixed and\ndoes not change.',
                  style: TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}