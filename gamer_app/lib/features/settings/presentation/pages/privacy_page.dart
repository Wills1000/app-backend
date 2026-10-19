import 'package:flutter/material.dart';
import '../widgets/settings_tile.dart';
import '../widgets/settings_switch_tile.dart';
import '../widgets/settings_section.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  // Privacy preferences
  String profileVisibility = 'Everyone';
  bool showOnlineStatus = true;
  bool allowFriendRequests = true;
  bool hideMatchHistory = false;

  static const Color accentRed = Color(0xFFFF3333);

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
          'Privacy',
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
          SettingsSection(
            children: [
              // Profile Visibility
              SettingsTile(
                icon: Icons.visibility_outlined,
                title: 'Profile Visibility',
                subtitle: profileVisibility,
                onTap: () => _showVisibilityPicker(context),
              ),

              // Show Online Status
              SettingsSwitchTile(
                icon: Icons.circle_outlined,
                title: 'Show Online Status',
                subtitle: 'Let friends see when you are active',
                value: showOnlineStatus,
                onChanged: (val) => setState(() => showOnlineStatus = val),
              ),

              // Allow Friend Requests
              SettingsSwitchTile(
                icon: Icons.person_add_outlined,
                title: 'Allow Friend Requests',
                subtitle: 'Allow other gamers to send you requests',
                value: allowFriendRequests,
                onChanged: (val) => setState(() => allowFriendRequests = val),
              ),

              // Hide Match History
              SettingsSwitchTile(
                icon: Icons.history_toggle_off_rounded,
                title: 'Hide Match History',
                subtitle: 'Keep your past games and stats private',
                value: hideMatchHistory,
                onChanged: (val) => setState(() => hideMatchHistory = val),
              ),

              // Block List
              SettingsTile(
                icon: Icons.block_rounded,
                title: 'Block List',
                subtitle: 'Manage blocked users and accounts',
                onTap: () {
                  // Navigate to Blocked Users screen
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showVisibilityPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF101012),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final options = ['Everyone', 'Friends Only', 'Nobody'];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 12.0),
                child: Text(
                  'Profile Visibility',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...options.map(
                (option) => ListTile(
                  title: Text(
                    option,
                    style: TextStyle(
                      color: profileVisibility == option
                          ? accentRed
                          : Colors.white,
                      fontWeight: profileVisibility == option
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: profileVisibility == option
                      ? const Icon(Icons.check_rounded, color: accentRed)
                      : null,
                  onTap: () {
                    setState(() => profileVisibility = option);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}