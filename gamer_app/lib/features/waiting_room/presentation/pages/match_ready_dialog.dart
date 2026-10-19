import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MatchReadyDialog extends StatefulWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onAutoLaunch;

  const MatchReadyDialog({
    Key? key,
    this.onCancel,
    this.onAutoLaunch,
  }) : super(key: key);

  static Future<void> show(
  BuildContext context, {
  VoidCallback? onCancel,
  VoidCallback? onAutoLaunch,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false, // User must press CANCEL to close
    barrierColor: Colors.black.withOpacity(0.8), // Keeps WaitingRoomScreen visible behind dark overlay
    builder: (dialogContext) => MatchReadyDialog(
      onCancel: onCancel,
      onAutoLaunch: onAutoLaunch,
    ),
  );
}

  @override
  State<MatchReadyDialog> createState() => _MatchReadyDialogState();
}

class _MatchReadyDialogState extends State<MatchReadyDialog> {
  int _secondsRemaining = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _secondsRemaining = 0;
        });
        _handleGameLaunch();
      }
    });
  }

  void _handleGameLaunch() {
    if (mounted) {
      Navigator.of(context).pop(); // Close the dialog
      if (widget.onAutoLaunch != null) {
        widget.onAutoLaunch!();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Launching Game...'),
            backgroundColor: Color(0xFF00E676),
          ),
        );
      }
    }
  }

  void _handleCancel() {
    _timer?.cancel();
    Navigator.of(context).pop();
    if (widget.onCancel != null) {
      widget.onCancel!();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = '00:${_secondsRemaining.toString().padLeft(2, '0')}';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF121214),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF00E676).withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00E676).withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status Title
            const Text(
              'MATCH READY!',
              style: TextStyle(
                color: Color(0xFF00E676),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Both players are ready to battle',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 24),

            // Avatars Matchup
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPlayerAvatar('DaPrince', 'https://i.pravatar.cc/150?img=11'),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildPlayerAvatar('qqgamerbeast', 'https://i.pravatar.cc/150?img=33'),
              ],
            ),
            const SizedBox(height: 28),

            // Timer Display
            const Text(
              'GAME STARTING IN',
              style: TextStyle(color: AppColors.textMuted, fontSize: 10, letterSpacing: 1),
            ),
            const SizedBox(height: 4),
            Text(
              formattedTime,
              style: const TextStyle(
                color: Color(0xFF00E676),
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'The game will open automatically',
              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 24),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: _handleCancel,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'CANCEL',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerAvatar(String name, String url) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(2.5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF00E676),
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(url),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: const [
            Icon(Icons.circle, color: Color(0xFF00E676), size: 6),
            SizedBox(width: 4),
            Text(
              'Ready',
              style: TextStyle(color: Color(0xFF00E676), fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }
}