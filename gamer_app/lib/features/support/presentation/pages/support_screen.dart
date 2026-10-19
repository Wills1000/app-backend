import 'package:flutter/material.dart';
import '../widgets/support_header.dart';
import '../widgets/contact_option.dart';
import 'package:gamer_app/core/widgets/app_background.dart';

class SupportScreen extends StatelessWidget {
  static const String routeName = '/support';

  const SupportScreen({super.key});

  static const Color primaryRed = Color(0xFF970303);
  static const Color cardBg = Color(0xFF141416);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090304),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Support',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: AppBackground(
  child: SafeArea(
    child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Hero Banner
            const SupportHeader(),
            const SizedBox(height: 24),

            // Section 1: Contact Options
            const Text(
              'Contact Options',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Top Grid (FAQ & Live Chat)
            Row(
              children: [
                Expanded(
                  child: _buildGridTile(
                    title: 'FAQ',
                    subtitle: 'Find answers',
                    icon: Icons.help_outline_rounded,
                    onTap: () {
                      // Navigate to faq_screen.dart
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGridTile(
                    title: 'Live Chat',
                    subtitle: 'Chat with us',
                    icon: Icons.chat_bubble_outline_rounded,
                    onTap: () {
                      // Navigate to chat_support_screen.dart
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // List Item: Email Us
            ContactOption(
              title: 'Email Us',
              subtitle: 'support@gamerapp.com',
              icon: Icons.mail_outline_rounded,
              onTap: () {
                // Trigger email intent or navigate to contact_support_screen.dart
              },
            ),

            // List Item: Report a User
            ContactOption(
              title: 'Report a User',
              subtitle: 'Report inappropriate behavior',
              icon: Icons.person_remove_outlined,
              onTap: () {
                // Navigate to report_bug_screen.dart or report flow
              },
            ),

            const SizedBox(height: 24),

            // Section 2: Community
            const Text(
              'Community',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Community Option: Join Discord
            ContactOption(
              title: 'Join our Discord',
              subtitle: 'Connect with players',
              icon: Icons.discord,
              customIconWidget: const Icon(
                Icons.discord,
                color: Color(0xFF5865F2), // Discord signature blurple color
                size: 26,
              ),
              onTap: () {
                // Open Discord link
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
  ),
      ),
    );
  }

  // Helper Widget for the FAQ & Live Chat Grid Boxes
  Widget _buildGridTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  border: Border.all(color: primaryRed.withOpacity(0.4), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: primaryRed.withOpacity(0.25),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: primaryRed,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}