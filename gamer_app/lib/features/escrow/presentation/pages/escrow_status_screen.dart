import 'package:flutter/material.dart';
import '../widgets/escrow_card.dart';
import 'escrow_details_screen.dart';

class EscrowStatusScreen extends StatefulWidget {
  const EscrowStatusScreen({Key? key}) : super(key: key);

  @override
  State<EscrowStatusScreen> createState() => _EscrowStatusScreenState();
}

class _EscrowStatusScreenState extends State<EscrowStatusScreen> {
  int selectedFilter = 0; // 0: All, 1: Locked, 2: Awaiting, 3: Completed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121214),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Escrow',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Header Stats Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF16161A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Total Escrowed',
                        style: TextStyle(color: Colors.white54, fontSize: 11),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '₦45,000',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '4 Active Escrows',
                        style: TextStyle(color: Colors.white38, fontSize: 10),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE50914).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: Color(0xFFE50914),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Fixed Non-Scrollable Capsule Tab Bar Container
            Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF16161A),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildFilterTab('All (4)', 0)),
                  Expanded(child: _buildFilterTab('Locked (2)', 1)),
                  Expanded(child: _buildFilterTab('Awaiting (1)', 2)),
                  Expanded(child: _buildFilterTab('Completed (1)', 3)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Escrow Cards List
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  EscrowCard(
                    title: 'COD Mobile 1v1',
                    subtitle: '1v1 • Battle Royale',
                    status: 'LOCKED',
                    yourStake: '₦5,000',
                    oppStake: '₦5,000',
                    totalEscrow: '₦10,000',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EscrowDetailsScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  EscrowCard(
                    title: 'PUBG Mobile 1v1',
                    subtitle: '1v1 • Classic',
                    status: 'LOCKED',
                    yourStake: '₦4,000',
                    oppStake: '₦4,000',
                    totalEscrow: '₦8,000',
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  EscrowCard(
                    title: 'Free Fire 1v1',
                    subtitle: '1v1 • Clash Squad',
                    status: 'AWAITING',
                    yourStake: '₦2,500',
                    oppStake: '₦2,500',
                    totalEscrow: '₦5,000',
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  EscrowCard(
                    title: 'eFootball 1v1',
                    subtitle: '1v1 • Event Match',
                    status: 'COMPLETED',
                    yourStake: '₦3,000',
                    oppStake: '₦3,000',
                    totalEscrow: '₦6,000',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fixed Tab Builder
  Widget _buildFilterTab(String label, int index) {
    final isSelected = selectedFilter == index;

    return GestureDetector(
      onTap: () => setState(() => selectedFilter = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE50914) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white54,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}