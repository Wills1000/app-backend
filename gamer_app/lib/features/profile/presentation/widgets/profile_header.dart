import 'package:flutter/material.dart';
import 'profile_avatar.dart';
import 'package:gamer_app/features/wallet/presentation/pages/wallet_screen.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String username;
  final String country;
  final String bio;
  final String avatarUrl;
  final int level;
  final VoidCallback onEditProfile;
  final VoidCallback onWalletTap;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.username,
    required this.country,
    required this.bio,
    required this.avatarUrl,
    required this.level,
    required this.onEditProfile,
    required this.onWalletTap,
  });

  static const Color primaryRed = Color(0xFF970303);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar with level & online badge
        ProfileAvatar(
          imageUrl: avatarUrl,
          level: level,
        ),
        const SizedBox(width: 16),

        // Details + Action Buttons
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Username + Verified Badge
              Row(
                children: [
                  Flexible(
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: primaryRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 12),
                  ),
                ],
              ),
              const SizedBox(height: 2),

              // Handle
              Text(
                '@$username',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 4),

              // Country Flag / Location
              Row(
                children: [
                  const Text('🇳🇬 ', style: TextStyle(fontSize: 12)),
                  Text(
                    country,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Bio
              Text(
                bio,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11.5,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Action Buttons Row: Edit Profile & Wallet
              Row(
                children: [
                  // Edit Profile Button
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: OutlinedButton.icon(
                        onPressed: onEditProfile,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: primaryRed, width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                        ),
                        icon: const Icon(Icons.edit_note, color: Colors.white, size: 18),
                        label: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Wallet Button
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: ElevatedButton.icon(
                        onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const WalletScreen(),
    ),
  );
},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryRed,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        icon: const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 16),
                        label: const Text(
                          'Wallet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}