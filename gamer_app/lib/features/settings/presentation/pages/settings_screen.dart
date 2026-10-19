import 'package:flutter/material.dart';
import '../widgets/settings_tile.dart';
import '../widgets/settings_section.dart';
import 'package:gamer_app/features/support/presentation/pages/support_screen.dart';
import 'package:gamer_app/core/widgets/app_background.dart';

// Imports mapped to your existing pages in presentation/pages/
import 'account_page.dart';
import 'language_page.dart';
import 'notifications_page.dart';
import 'privacy_page.dart';
import 'sound_page.dart';
import 'security_page.dart';


class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  void _navigateTo(BuildContext context, Widget targetPage) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => targetPage),
    );
  }

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
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        physics: const BouncingScrollPhysics(),
        child: SettingsSection(
          children: [
            SettingsTile(
              icon: Icons.person_outline_rounded,
              title: 'Account',
              subtitle: 'Manage your account',
              onTap: () => _navigateTo(context, const AccountPage()),
            ),
            SettingsTile(
              icon: Icons.shield_outlined,
              title: 'Security',
              subtitle: 'Password, 2FA, devices',
              onTap: () => _navigateTo(context, const SecurityPage()),
            ),
            SettingsTile(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              subtitle: 'Manage notification preferences',
              onTap: () => _navigateTo(context, const NotificationsPage()),
            ),
            SettingsTile(
              icon: Icons.volume_up_outlined,
              title: 'Sounds & Vibration',
              subtitle: 'Music, SFX, Vibration',
              onTap: () => _navigateTo(context, const SoundPage()),
            ),
            
            SettingsTile(
              icon: Icons.lock_outline_rounded,
              title: 'Privacy',
              subtitle: 'Privacy and visibility',
              onTap: () => _navigateTo(context, const PrivacyPage()),
            ),
            SettingsTile(
              icon: Icons.language_rounded,
              title: 'Language',
              subtitle: 'English',
              onTap: () => _navigateTo(context, const LanguagePage()),
            ),
            SettingsTile(
  icon: Icons.help_outline_rounded,
  title: 'Help & Support',
  subtitle: 'Get help and support',
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SupportScreen(),
      ),
    );
  },
),
          ],
        ),
      ),
    );
  }
}