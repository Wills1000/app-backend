import 'package:flutter/material.dart';
import '../widgets/opponent_info_card.dart';
import '../widgets/stake_info_card.dart';
import '../widgets/challenge_rules_preview.dart';
import '../widgets/accept_button.dart';
import '../widgets/decline_button.dart';
import 'package:gamer_app/features/waiting_room/presentation/pages/waiting_room_screen.dart';

class ChallengeAcceptanceSheet extends StatefulWidget {
  const ChallengeAcceptanceSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ChallengeAcceptanceSheet(),
    );
  }

  @override
  State<ChallengeAcceptanceSheet> createState() => _ChallengeAcceptanceSheetState();
}

class _ChallengeAcceptanceSheetState extends State<ChallengeAcceptanceSheet> {
  int _currentState = 0; // 0: Review, 1: Loading, 2: Success

  void _handleAcceptance() async {
    setState(() => _currentState = 1); // Loading
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _currentState = 2); // Success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121215),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildCurrentStateView(),
      ),
    );
  }

  Widget _buildCurrentStateView() {
    switch (_currentState) {
      case 1:
        return _buildLoadingState();
      case 2:
        return _buildSuccessState();
      default:
        return _buildReviewState();
    }
  }

  // State 0: Initial Challenge Acceptance Review Sheet
  Widget _buildReviewState() {
    return Column(
      key: const ValueKey(0),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 16),

        const Center(
          child: Text(
            'Accept Challenge',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),

        // Game Header Preview
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF16161A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.sports_esports, color: Colors.redAccent),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Call of Duty: Mobile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 2),
                  Text('Team Deathmatch • Public', style: TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Opponent Info
        const OpponentInfoCard(
          username: 'qgamerbeast',
          winRate: '78%',
          totalMatches: 124,
        ),
        const SizedBox(height: 12),

        // Stake Breakdown
        const StakeInfoCard(
          playerStake: 500,
          fee: 500,
          potentialWin: 900,
        ),
        const SizedBox(height: 14),

        // Rules Section
        const Text('Rules', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const ChallengeRulesPreview(),
        const SizedBox(height: 20),

        // Action Buttons
        Row(
          children: [
            Expanded(child: DeclineButton(onPressed: () => Navigator.pop(context))),
            const SizedBox(width: 12),
            Expanded(flex: 2, child: AcceptButton(onPressed: _handleAcceptance)),
          ],
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'By accepting, you agree to our Terms of Service & Fair Play Policy.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 10),
          ),
        ),
      ],
    );
  }

  // State 1: Accepting Challenge Radar/Loading State
  Widget _buildLoadingState() {
    return Padding(
      key: const ValueKey(1),
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFF2233).withOpacity(0.2), width: 8),
                ),
              ),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFF2233).withOpacity(0.5), width: 4),
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF2233),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield_outlined, color: Colors.white, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Accepting Challenge', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text('Please wait...', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
          const SizedBox(height: 24),

          // Loading Steps
          _buildLoadingStep(Icons.check_circle_outline, 'Sending request to opponent', true),
          _buildLoadingStep(Icons.check_circle_outline, 'Securing escrow for challenge', true),
          _buildLoadingStep(Icons.radio_button_unchecked, 'Finalizing acceptance', false),
        ],
      ),
    );
  }

  // State 2: Challenge Accepted Success State
  Widget _buildSuccessState() {
    return Padding(
      key: const ValueKey(2),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF00E676).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Color(0xFF00E676), size: 48),
          ),
          const SizedBox(height: 16),
          const Text('Challenge Accepted!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: 4),
          Text('You have accepted the challenge.', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF16161A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.sports_esports, color: Colors.white70, size: 20),
                    SizedBox(width: 8),
                    Text('Call of Duty: Mobile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const Divider(color: Colors.white10, height: 20),
                _buildSummaryRow('Player Stake', '500 Coins'),
                _buildSummaryRow('Potential Win', '900 Coins', isHighlight: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Next Step:\nPreparing to enter room...', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
          const SizedBox(height: 16),
          AcceptButton(
  label: 'Continue',
  onPressed: () {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const WaitingRoomScreen(),
      ),
    );
  },
),
        ],
      ),
    );
  }

  Widget _buildLoadingStep(IconData icon, String text, bool isDone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: isDone ? const Color(0xFFFF2233) : Colors.white24, size: 16),
          const SizedBox(width: 10),
          Text(text, style: TextStyle(color: isDone ? Colors.white70 : Colors.white24, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String val, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
          Text(
            val,
            style: TextStyle(
              color: isHighlight ? const Color(0xFF00E676) : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}