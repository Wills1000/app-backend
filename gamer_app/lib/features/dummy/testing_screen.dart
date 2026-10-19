import 'package:flutter/material.dart';

// CHALLENGE
import 'package:gamer_app/features/challenge/presentation/pages/challenge_details_screen.dart';

// CHALLENGE ACCEPTANCE
import 'package:gamer_app/features/challenge_acceptance/presentation/pages/challenge_acceptance_sheet.dart';

// WAITING ROOM
import 'package:gamer_app/features/waiting_room/presentation/pages/waiting_room_screen.dart';

// RESULT SUBMISSION
import 'package:gamer_app/features/result_submission/presentation/pages/result_submission_sheet.dart';
import 'package:gamer_app/features/result_submission/presentation/pages/proof_upload_sheet.dart';
import 'package:gamer_app/features/result_submission/presentation/pages/dispute_screen.dart';

// WINNER CONFIRMATION
import 'package:gamer_app/features/winner_confirmation/presentation/pages/winner_dialog.dart';
import 'package:gamer_app/features/winner_confirmation/presentation/pages/loser_dialog.dart';
import 'package:gamer_app/features/winner_confirmation/presentation/pages/no_response_dialog.dart';

// ESCROW
import 'package:gamer_app/features/escrow/presentation/pages/escrow_status_screen.dart';
import 'package:gamer_app/features/escrow/presentation/pages/escrow_details_screen.dart';

import 'package:gamer_app/features/escrow/presentation/dialogs/escrow_timeline_sheet.dart';
import 'package:gamer_app/features/escrow/presentation/dialogs/escrow_breakdown_sheet.dart';

class TestingScreen extends StatelessWidget {
  const TestingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090304),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'UI Testing',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            const Text(
              'Challenge Flow',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _testButton(
              context,
              title: 'Challenge Details',
              subtitle: 'View challenge information',
              icon: Icons.info_outline,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChallengeDetailsScreen(),
                  ),
                );
              },
            ),

            _testButton(
              context,
              title: 'Challenge Acceptance',
              subtitle: 'Open acceptance bottom sheet',
              icon: Icons.handshake_outlined,
              onPressed: () {
                ChallengeAcceptanceSheet.show(context);
              },
            ),

            const SizedBox(height: 24),

            const Text(
              'Waiting Room',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _testButton(
              context,
              title: 'Waiting Room',
              subtitle: 'View players waiting for the match',
              icon: Icons.people_outline,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WaitingRoomScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            const Text(
              'Result Submission',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _testButton(
              context,
              title: 'Result Submission',
              subtitle: 'Submit your match score',
              icon: Icons.scoreboard_outlined,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ResultSubmissionSheet(),
                  ),
                );
              },
            ),

            _testButton(
              context,
              title: 'Proof Upload',
              subtitle: 'Upload proof when scores do not match',
              icon: Icons.upload_file_outlined,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProofUploadSheet(),
                  ),
                );
              },
            ),

            _testButton(
              context,
              title: 'Dispute',
              subtitle: 'Open a challenge dispute',
              icon: Icons.report_problem_outlined,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DisputeScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            const Text(
              'Winner Confirmation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _testButton(
              context,
              title: 'Winner Dialog',
              subtitle: 'Preview winner confirmation',
              icon: Icons.emoji_events_outlined,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const WinnerDialog(),
                );
              },
            ),

            _testButton(
              context,
              title: 'No Response Dialog',
              subtitle: 'Preview opponent timeout',
              icon: Icons.timer_off_outlined,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const NoResponseDialog(),
                );
              },
            ),

            const SizedBox(height: 30),

            const SizedBox(height: 24),

const Text(
  'Escrow',
  style: TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 12),

_testButton(
  context,
  title: 'Escrow Overview',
  subtitle: 'View all active escrowed challenges',
  icon: Icons.account_balance_wallet_outlined,
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EscrowStatusScreen(),
      ),
    );
  },
),

_testButton(
  context,
  title: 'Escrow Details',
  subtitle: 'View one escrow and its locked funds',
  icon: Icons.lock_outline,
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EscrowDetailsScreen(),
      ),
    );
  },
),

_testButton(
  context,
  title: 'Escrow Timeline',
  subtitle: 'View escrow progress and status',
  icon: Icons.timeline_outlined,
  onPressed: () {
    EscrowTimelineSheet.show(context);
  },
),

_testButton(
  context,
  title: 'Escrow Breakdown',
  subtitle: 'View stake, opponent stake and total escrow',
  icon: Icons.receipt_long_outlined,
  onPressed: () {
    EscrowBreakdownSheet.show(context);
  },
),

_testButton(
  context,
  title: 'Cancel Escrow',
  subtitle: 'Preview escrow cancellation confirmation',
  icon: Icons.cancel_outlined,
  onPressed: () {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xff141416),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: Colors.white.withOpacity(0.06),
          ),
        ),
        title: const Text(
          'Cancel Escrow?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'If you cancel this escrow, the challenge will be terminated and the funds will be refunded according to the escrow rules.',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 13,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Keep Escrow',
              style: TextStyle(
                color: Colors.white60,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffE50914),
            ),
            child: const Text(
              'Cancel Escrow',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  },
),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xff141416),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
              child: const Text(
                'This page is only for development/testing. '
                'You can remove it when the real challenge flow is fully connected.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _testButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: const Color(0xff141416),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xffE50914).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xffE50914),
                    size: 22,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white24,
                  size: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}