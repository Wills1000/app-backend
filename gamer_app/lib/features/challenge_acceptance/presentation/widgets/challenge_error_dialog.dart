import 'package:flutter/material.dart';

class ChallengeErrorDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const ChallengeErrorDialog({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF16161A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 36),
            ),
            const SizedBox(height: 14),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF2233),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(buttonText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Decline Challenge Confirm Dialog
  static void showDeclineConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF16161A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.12), shape: BoxShape.circle),
                child: const Icon(Icons.close, color: Colors.redAccent, size: 36),
              ),
              const SizedBox(height: 14),
              const Text('Decline Challenge?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              Text('Are you sure you want to decline this challenge?', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white.withOpacity(0.15))),
                      child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2233)),
                      child: const Text('Decline', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 2. Opponent Busy Dialog
  static void showOpponentBusy(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ChallengeErrorDialog(
        icon: Icons.info_outline_rounded,
        iconColor: Colors.blueAccent,
        title: 'Opponent is Busy',
        message: 'The host is currently in another Challenge. Please try again later.',
        buttonText: 'OK',
        onButtonPressed: () => Navigator.pop(context),
      ),
    );
  }

  // 3. Challenge Expired Dialog
  static void showExpired(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ChallengeErrorDialog(
        icon: Icons.access_time_rounded,
        iconColor: Colors.amber,
        title: 'Challenge Expired',
        message: 'This challenge is no longer available.',
        buttonText: 'OK',
        onButtonPressed: () => Navigator.pop(context),
      ),
    );
  }

  // 4. Insufficient Balance Dialog
  static void showInsufficientBalance(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ChallengeErrorDialog(
        icon: Icons.account_balance_wallet_outlined,
        iconColor: Colors.redAccent,
        title: 'Insufficient Balance',
        message: "You don't have enough coins to accept this challenge.",
        buttonText: 'Top Up Wallet',
        onButtonPressed: () => Navigator.pop(context),
      ),
    );
  }

  // 5. Region Restricted Dialog
  static void showRegionRestricted(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ChallengeErrorDialog(
        icon: Icons.public_off_outlined,
        iconColor: Colors.purpleAccent,
        title: 'Region Restricted',
        message: 'You are not allowed to accept challenges in this region.',
        buttonText: 'OK',
        onButtonPressed: () => Navigator.pop(context),
      ),
    );
  }

  // 6. Acceptance Failed Dialog
  static void showAcceptanceFailed(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ChallengeErrorDialog(
        icon: Icons.cancel_outlined,
        iconColor: Colors.redAccent,
        title: 'Acceptance Failed',
        message: 'Something went wrong while accepting the challenge.',
        buttonText: 'Try Again',
        onButtonPressed: () => Navigator.pop(context),
      ),
    );
  }

  // 7. Connection Lost Dialog
  static void showConnectionLost(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ChallengeErrorDialog(
        icon: Icons.wifi_off_rounded,
        iconColor: Colors.amber,
        title: 'Connection Lost',
        message: 'Please check your internet connection and try again.',
        buttonText: 'Retry',
        onButtonPressed: () => Navigator.pop(context),
      ),
    );
  }
}