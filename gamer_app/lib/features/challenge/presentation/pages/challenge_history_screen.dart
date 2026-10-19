import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_background.dart';
import '../widgets/challenge_card.dart';
import '../../domain/entities/challenge_history.dart';

class ChallengeHistoryScreen extends StatefulWidget {
  const ChallengeHistoryScreen({Key? key}) : super(key: key);

  @override
  _ChallengeHistoryScreenState createState() => _ChallengeHistoryScreenState();
}

class _ChallengeHistoryScreenState extends State<ChallengeHistoryScreen> {
  String selectedFilter = 'All';

  final List<ChallengeHistoryItem> items = const [
    ChallengeHistoryItem(id: '1', gameTitle: 'Call of Duty', mode: 'Team Deathmatch', opponentUsername: '@shadowx', result: 'Won', score: '2 - 1', wager: 500, timeAgo: '2h ago'),
    ChallengeHistoryItem(id: '2', gameTitle: 'PUBG Mobile', mode: 'Squad', opponentUsername: '@venomyt', result: 'Lost', score: '1 - 2', wager: 800, timeAgo: '1d ago'),
    ChallengeHistoryItem(id: '3', gameTitle: 'Free Fire MAX', mode: 'Clash Squad', opponentUsername: '@killerzone', result: 'Cancelled', score: '-', wager: 300, timeAgo: '2d ago'),
    ChallengeHistoryItem(id: '4', gameTitle: 'FC Mobile', mode: 'Head to Head', opponentUsername: '@ronaldo7', result: 'Won', score: '3 - 1', wager: 1000, timeAgo: '3d ago'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
        title: const Text('Challenge History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: ['All', 'Created', 'Participated'].map((filter) {
                    final isSelected = selectedFilter == filter;
                    return GestureDetector(
                      onTap: () => setState(() => selectedFilter = filter),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryRed : AppColors.cardBg.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(filter, style: TextStyle(color: isSelected ? AppColors.textWhite : AppColors.textMuted, fontSize: 12)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => ChallengeCard(item: items[index]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}