import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_background.dart';
import '../widgets/match_info_card.dart';
import '../widgets/player_card.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/room_code_card.dart';
import 'match_ready_dialog.dart';

enum WaitingRoomStatus { searching, opponentJoined, bothReady }

class WaitingRoomScreen extends StatefulWidget {
  final WaitingRoomStatus initialStatus;

  const WaitingRoomScreen({
    Key? key,
    this.initialStatus = WaitingRoomStatus.opponentJoined,
  }) : super(key: key);

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  late WaitingRoomStatus currentStatus;
  bool isCurrentUserReady = false;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.initialStatus;
  }

  void _triggerMatchReadyDialog() {
    MatchReadyDialog.show(
      context,
      onCancel: () {
        setState(() {
          isCurrentUserReady = false;
          currentStatus = WaitingRoomStatus.opponentJoined;
        });
      },
      onAutoLaunch: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Opening Call of Duty: Mobile...'),
            backgroundColor: Color(0xFF00E676),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textWhite, size: 18),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'WAITING ROOM',
          style: TextStyle(color: AppColors.textWhite, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_outlined, color: AppColors.primaryRed),
            onPressed: () {},
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                // Top Status bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: const TextSpan(
                        text: 'Room ID: ',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                        children: [
                          TextSpan(text: '7X2K9L', style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    _buildStatusBadge(),
                  ],
                ),
                const SizedBox(height: 12),

                // Game Title Banner
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey[900],
                          child: const Icon(Icons.sports_esports, color: AppColors.textWhite),
                        ),
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
                const SizedBox(height: 10),

                // Financial Stakes Card
                const MatchInfoCard(),
                const SizedBox(height: 10),

                // Countdown Timer
                if (currentStatus != WaitingRoomStatus.searching)
                  const CountdownTimerWidget(timeString: '02:15'),

                const SizedBox(height: 10),

                // Player Matchup Section
                Row(
                  children: [
                    Expanded(
                      child: PlayerCard(
                        username: 'DaPrince',
                        avatarUrl: 'https://i.pravatar.cc/150?img=11',
                        country: 'Nigeria',
                        gameId: 'DaPrince123',
                        isReady: isCurrentUserReady || currentStatus == WaitingRoomStatus.bothReady,
                        isCurrentUser: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: const Text('VS', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                    Expanded(
                      child: PlayerCard(
                        username: 'qqgamerbeast',
                        avatarUrl: 'https://i.pravatar.cc/150?img=33',
                        country: 'Nigeria',
                        gameId: 'BeastCOD',
                        isReady: currentStatus == WaitingRoomStatus.bothReady,
                        isSearching: currentStatus == WaitingRoomStatus.searching,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Custom Match Room Code
                if (currentStatus != WaitingRoomStatus.searching)
                  const RoomCodeCard(roomCode: '824728'),

                const SizedBox(height: 12),

                // Action Buttons
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    switch (currentStatus) {
      case WaitingRoomStatus.searching:
        return const Text('Searching for opponent...', style: TextStyle(color: Colors.amber, fontSize: 11));
      case WaitingRoomStatus.opponentJoined:
        return Row(
          children: const [
            Icon(Icons.check_circle_outline, color: Color(0xFF00E676), size: 14),
            SizedBox(width: 4),
            Text('Opponent joined', style: TextStyle(color: Color(0xFF00E676), fontSize: 11)),
          ],
        );
      case WaitingRoomStatus.bothReady:
        return Row(
          children: const [
            Icon(Icons.check_circle_outline, color: Color(0xFF00E676), size: 14),
            SizedBox(width: 4),
            Text('Both players are ready', style: TextStyle(color: Color(0xFF00E676), fontSize: 11)),
          ],
        );
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    if (currentStatus == WaitingRoomStatus.searching) {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton(
          onPressed: () => Navigator.maybePop(context),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.white.withOpacity(0.2)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('CANCEL SEARCH', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.maybePop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withOpacity(0.2)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('LEAVE MATCH', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                if (currentStatus == WaitingRoomStatus.bothReady) {
                  _triggerMatchReadyDialog();
                } else {
                  setState(() {
                    isCurrentUserReady = true;
                    currentStatus = WaitingRoomStatus.bothReady;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                currentStatus == WaitingRoomStatus.bothReady ? 'LAUNCH GAME' : "I'M READY",
                style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}