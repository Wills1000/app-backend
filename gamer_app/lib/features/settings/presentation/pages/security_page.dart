import 'package:flutter/material.dart';
import '../widgets/settings_tile.dart';
import '../widgets/settings_section.dart';
import '../widgets/logout_dialog.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool isTwoFactorEnabled = false;
  int trustedDeviceCount = 3;

  void _showChangePasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Change Password', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Current Password',
                hintStyle: TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            const TextField(
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'New Password',
                hintStyle: TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF970303),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Update Password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSimpleListSheet(BuildContext context, String title, List<Widget> items) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...items,
          ],
        ),
      ),
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Security', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        children: [
          SettingsSection(
            children: [
              SettingsTile(
                icon: Icons.lock_reset_rounded,
                title: 'Change Password',
                subtitle: 'Update your login password',
                onTap: () => _showChangePasswordSheet(context),
              ),
              SettingsTile(
                icon: Icons.phonelink_lock_rounded,
                title: 'Two-Factor Authentication',
                subtitle: isTwoFactorEnabled ? 'ON' : 'OFF',
                onTap: () {
                  setState(() {
                    isTwoFactorEnabled = !isTwoFactorEnabled;
                  });
                },
              ),
              SettingsTile(
                icon: Icons.devices_rounded,
                title: 'Trusted Devices',
                subtitle: '$trustedDeviceCount Devices',
                onTap: () {
                  _showSimpleListSheet(
                    context,
                    'Trusted Devices',
                    const [
                      ListTile(
                        leading: Icon(Icons.phone_android, color: Colors.white70),
                        title: Text('Infinix Note 30', style: TextStyle(color: Colors.white)),
                        subtitle: Text('This Device • Active now', style: TextStyle(color: Colors.white38)),
                      ),
                      ListTile(
                        leading: Icon(Icons.laptop, color: Colors.white70),
                        title: Text('Windows PC (VS Code)', style: TextStyle(color: Colors.white)),
                        subtitle: Text('Logged in 2 days ago', style: TextStyle(color: Colors.white38)),
                      ),
                    ],
                  );
                },
              ),
              SettingsTile(
                icon: Icons.history_toggle_off_rounded,
                title: 'Login History',
                subtitle: 'View recent account activity',
                onTap: () {
                  _showSimpleListSheet(
                    context,
                    'Recent Login Activity',
                    const [
                      ListTile(
                        title: Text('Port Harcourt, Nigeria', style: TextStyle(color: Colors.white)),
                        subtitle: Text('Today at 07:35 AM', style: TextStyle(color: Colors.white38)),
                      ),
                      ListTile(
                        title: Text('Lagos, Nigeria', style: TextStyle(color: Colors.white)),
                        subtitle: Text('Yesterday at 04:12 PM', style: TextStyle(color: Colors.white38)),
                      ),
                    ],
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
                subtitle: 'Sign out from this account',
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
            ],
          ),
        ],
      ),
    );
  }
}