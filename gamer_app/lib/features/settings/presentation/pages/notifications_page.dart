import 'package:flutter/material.dart';
import '../widgets/settings_switch_tile.dart';
import '../widgets/settings_section.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Initial switch states matching your specs
  bool matchInvitations = true;
  bool friendRequests = true;
  bool tournamentAlerts = true;
  bool walletTransactions = true;
  bool challengeUpdates = true;
  bool announcements = false;
  bool sound = true;
  bool vibration = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        physics: const BouncingScrollPhysics(),
        children: [
          // Activity Notifications
          SettingsSection(
            children: [
              SettingsSwitchTile(
                icon: Icons.sports_esports_outlined,
                title: 'Match Invitations',
                subtitle: 'Get notified when players invite you to a game',
                value: matchInvitations,
                onChanged: (val) => setState(() => matchInvitations = val),
              ),
              SettingsSwitchTile(
                icon: Icons.person_add_alt_1_outlined,
                title: 'Friend Requests',
                subtitle: 'Alerts when someone wants to connect',
                value: friendRequests,
                onChanged: (val) => setState(() => friendRequests = val),
              ),
              SettingsSwitchTile(
                icon: Icons.emoji_events_outlined,
                title: 'Tournament Alerts',
                subtitle: 'Updates on your registered tournaments',
                value: tournamentAlerts,
                onChanged: (val) => setState(() => tournamentAlerts = val),
              ),
              SettingsSwitchTile(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Wallet Transactions',
                subtitle: 'Alerts on deposits, withdrawals, and payouts',
                value: walletTransactions,
                onChanged: (val) => setState(() => walletTransactions = val),
              ),
              SettingsSwitchTile(
                icon: Icons.flag_outlined,
                title: 'Challenge Updates',
                subtitle: 'Notifications about ongoing stakes and challenges',
                value: challengeUpdates,
                onChanged: (val) => setState(() => challengeUpdates = val),
              ),
              SettingsSwitchTile(
                icon: Icons.campaign_outlined,
                title: 'Announcements',
                subtitle: 'News, platform updates, and promo offers',
                value: announcements,
                onChanged: (val) => setState(() => announcements = val),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Alert Styles (Sound & Vibration)
          SettingsSection(
            children: [
              SettingsSwitchTile(
                icon: Icons.volume_up_outlined,
                title: 'Sound',
                subtitle: 'Play audio sound for incoming alerts',
                value: sound,
                onChanged: (val) => setState(() => sound = val),
              ),
              SettingsSwitchTile(
                icon: Icons.vibration_rounded,
                title: 'Vibration',
                subtitle: 'Vibrate on new notifications',
                value: vibration,
                onChanged: (val) => setState(() => vibration = val),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}