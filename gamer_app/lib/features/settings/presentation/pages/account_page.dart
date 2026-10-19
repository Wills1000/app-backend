import 'package:flutter/material.dart';
import '../widgets/settings_tile.dart';
import '../widgets/settings_section.dart';
import '../widgets/logout_dialog.dart';
import '../widgets/delete_account_dialog.dart';

// Import your sub-pages here
import 'edit_profile_page.dart';
import 'email_page.dart';
import 'phone_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        children: [
          SettingsSection(
            children: [
              SettingsTile(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                subtitle: 'Update username, bio, and avatar',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                },
              ),
              SettingsTile(
                icon: Icons.email_outlined,
                title: 'Email Address',
                subtitle: 'user@domain.com',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EmailPage()),
                  );
                },
              ),
              SettingsTile(
                icon: Icons.phone_android_outlined,
                title: 'Phone Number',
                subtitle: 'Add or change recovery phone',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PhonePage()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          SettingsSection(
            children: [
              SettingsTile(
                icon: Icons.logout_rounded,
                title: 'Log Out',
                subtitle: 'Sign out from this device',
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => const LogoutDialog(),
                  );
                  if (confirm == true && context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              SettingsTile(
                icon: Icons.delete_forever_rounded,
                title: 'Delete Account',
                subtitle: 'Permanently remove your data',
                onTap: () async {
                  await showDialog<bool>(
                    context: context,
                    builder: (_) => const DeleteAccountDialog(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}