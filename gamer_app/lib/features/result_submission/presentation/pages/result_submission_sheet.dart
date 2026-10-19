import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/winner_selector.dart';
import '../widgets/score_input.dart';
import 'proof_upload_sheet.dart';

enum SubmissionStep { confirmStart, selectScores, waitingForOpponent, confirmed, summary }

class ResultSubmissionSheet extends StatefulWidget {
  const ResultSubmissionSheet({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ResultSubmissionSheet(),
    );
  }

  @override
  State<ResultSubmissionSheet> createState() => _ResultSubmissionSheetState();
}

class _ResultSubmissionSheetState extends State<ResultSubmissionSheet> {
  SubmissionStep currentStep = SubmissionStep.confirmStart;
  String selectedWinner = 'DaPrince';
  final yourScoreController = TextEditingController(text: '25');
  final opponentScoreController = TextEditingController(text: '18');

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.88,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF121214),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildCurrentStepContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (currentStep) {
      case SubmissionStep.confirmStart:
        return _buildConfirmStartStep();
      case SubmissionStep.selectScores:
        return _buildSelectScoresStep();
      case SubmissionStep.waitingForOpponent:
        return _buildWaitingStep();
      case SubmissionStep.confirmed:
        return _buildConfirmedStep();
      case SubmissionStep.summary:
        return _buildSummaryStep();
    }
  }

  // STEP 1: SUBMIT RESULT INITIAL SCREEN
  Widget _buildConfirmStartStep() {
    return Column(
      children: [
        const Text(
          'SUBMIT RESULT',
          style: TextStyle(color: AppColors.textWhite, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        const SizedBox(height: 20),

        // Game Match Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(width: 44, height: 44, color: Colors.grey[900], child: const Icon(Icons.sports_esports, color: Colors.white)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Call of Duty: Mobile', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text('Team Deathmatch • 1v1 • Public', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Financial Metrics Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMetric('TOTAL STAKE', '₦10,000'),
            _buildMetric('ENTRY FEE', '₦5,000'),
            _buildMetric('POTENTIAL WIN', '₦9,000', color: const Color(0xFF00E676)),
          ],
        ),
        const SizedBox(height: 24),

        // Matchup Avatars
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAvatar('DaPrince (You)', 'https://i.pravatar.cc/150?img=11'),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 20.0), child: Text('VS', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 18))),
            _buildAvatar('qqgamerbeast', 'https://i.pravatar.cc/150?img=33'),
          ],
        ),

        const Spacer(),

        const Text('THE GAME IS COMPLETE?', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 4),
        const Text('Please confirm the match result below.', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => setState(() => currentStep = SubmissionStep.selectScores),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('SUBMIT RESULT', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 16, color: AppColors.textWhite),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white.withOpacity(0.1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('CANCEL MATCH', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            text: 'Results must be submitted within ',
            style: TextStyle(color: AppColors.textMuted, fontSize: 10),
            children: [
              TextSpan(text: '15 minutes\n', style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold)),
              TextSpan(text: 'after match completion.'),
            ],
          ),
        ),
      ],
    );
  }

  // STEP 2: SELECT WINNER & SCORES
  Widget _buildSelectScoresStep() {
    return Column(
      children: [
        const Text('SELECT RESULT', style: TextStyle(color: AppColors.textWhite, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        WinnerSelector(
          selectedWinnerId: selectedWinner,
          onWinnerSelected: (id) => setState(() => selectedWinner = id),
        ),
        const SizedBox(height: 24),
        ScoreInputWidget(
          yourScoreController: yourScoreController,
          opponentScoreController: opponentScoreController,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => setState(() => currentStep = SubmissionStep.waitingForOpponent),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('CONTINUE', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // STEP 3: WAITING FOR OPPONENT
  Widget _buildWaitingStep() {
    return Column(
      children: [
        const SizedBox(height: 12),
        const CircleAvatar(
          radius: 28,
          backgroundColor: Color(0x22E50914),
          child: Icon(Icons.hourglass_empty, color: AppColors.primaryRed, size: 28),
        ),
        const SizedBox(height: 12),
        const Text('RESULT SUBMITTED', style: TextStyle(color: AppColors.textWhite, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Waiting for qqgamerbeast to submit theirs.', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
        const SizedBox(height: 24),

        _buildSubmissionCard('YOUR SUBMISSION', 'DaPrince (You)', '${yourScoreController.text} - ${opponentScoreController.text}', 'Submitted just now', isDone: true),
        const SizedBox(height: 12),
        _buildSubmissionCard('OPPONENT SUBMISSION', 'qqgamerbeast', 'Pending...', '', isDone: false),

        const Spacer(),

        // Demo triggers
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => currentStep = SubmissionStep.confirmed),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF00E676))),
                child: const Text('Simulate Match', style: TextStyle(color: Color(0xFF00E676), fontSize: 10)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ProofUploadSheet.show(context);
                },
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primaryRed)),
                child: const Text('Simulate Mismatch', style: TextStyle(color: AppColors.primaryRed, fontSize: 10)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // STEP 4: SCORES MATCH (AUTO CONFIRMED)
  Widget _buildConfirmedStep() {
    return Column(
      children: [
        const SizedBox(height: 12),
        const CircleAvatar(
          radius: 28,
          backgroundColor: Color(0x2200E676),
          child: Icon(Icons.emoji_events, color: Color(0xFF00E676), size: 28),
        ),
        const SizedBox(height: 12),
        const Text('MATCH CONFIRMED!', style: TextStyle(color: Color(0xFF00E676), fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Both scores match. Winner has been confirmed.', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF16161A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('WINNER', style: TextStyle(color: AppColors.textMuted, fontSize: 10, letterSpacing: 1)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const CircleAvatar(radius: 16, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11')),
                  const SizedBox(width: 10),
                  const Text('DaPrince (You)', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF00E676).withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                    child: const Text('WINNER', style: TextStyle(color: Color(0xFF00E676), fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const Divider(height: 24, color: Colors.white10),
              const Text('YOU WON', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
              const SizedBox(height: 2),
              const Text('+₦9,000', style: TextStyle(color: Color(0xFF00E676), fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),

        const Spacer(),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => setState(() => currentStep = SubmissionStep.summary),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('VIEW MATCH SUMMARY', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white.withOpacity(0.1)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('BACK TO HOME', style: TextStyle(color: AppColors.textWhite, fontSize: 12)),
          ),
        ),
      ],
    );
  }

  // STEP 5: MATCH SUMMARY
  Widget _buildSummaryStep() {
    return Column(
      children: [
        const Icon(Icons.workspace_premium, color: Colors.amber, size: 36),
        const Text('VICTORY', style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildScoreSummary('25', 'YOUR SCORE'),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('VS', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.bold))),
            _buildScoreSummary('18', 'OPPONENT SCORE'),
          ],
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF16161A), borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('REWARDS', style: TextStyle(color: AppColors.textMuted, fontSize: 10, letterSpacing: 1)),
              const SizedBox(height: 12),
              _buildRewardRow('Winning Amount', '₦9,000'),
              _buildRewardRow('Total Stake Returned', '₦10,000'),
              const Divider(color: Colors.white10),
              _buildRewardRow('Total Earned', '₦9,000', color: const Color(0xFF00E676)),
            ],
          ),
        ),

        const Spacer(),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('VIEW TRANSACTION', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white.withOpacity(0.1)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('BACK TO HOME', style: TextStyle(color: AppColors.textWhite, fontSize: 12)),
          ),
        ),
      ],
    );
  }

  // Helpers
  Widget _buildMetric(String label, String val, {Color color = AppColors.textWhite}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 9, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(val, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildAvatar(String name, String url) {
    return Column(
      children: [
        CircleAvatar(radius: 24, backgroundImage: NetworkImage(url)),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(color: AppColors.textWhite, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSubmissionCard(String title, String name, String score, String time, {required bool isDone}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF16161A), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: AppColors.textMuted, fontSize: 9, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(name, style: const TextStyle(color: AppColors.textWhite, fontSize: 12, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(score, style: TextStyle(color: isDone ? AppColors.textWhite : AppColors.textMuted, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreSummary(String score, String label) {
    return Column(
      children: [
        Text(score, style: const TextStyle(color: AppColors.textWhite, fontSize: 28, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 9)),
      ],
    );
  }

  Widget _buildRewardRow(String label, String val, {Color color = AppColors.textWhite}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          Text(val, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}