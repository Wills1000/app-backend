import 'package:flutter/material.dart';
import '../widgets/notification_appbar.dart';
import '../widgets/notification_filter.dart';
import '../widgets/notification_card.dart';
import 'package:gamer_app/core/widgets/app_background.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = '/notifications';

  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedFilterIndex = 0;

  // Mock Notification Data matching your design image
  final List<NotificationCardItem> _notifications = const [
    NotificationCardItem(
      title: 'Challenge Accepted',
      message: 'Godkiller09 accepted your challenge for COD Mobile',
      timeAgo: '2m ago',
      isUnread: true,
      type: NotificationType.challenge,
    ),
    NotificationCardItem(
      title: 'Match Invite',
      message: 'ShadowX invited you to a match for PUBG Mobile',
      timeAgo: '10m ago',
      isUnread: true,
      type: NotificationType.match,
    ),
    NotificationCardItem(
      title: 'Friend Request',
      message: 'BeastModeK sent you a friend request',
      timeAgo: '25m ago',
      isUnread: true,
      type: NotificationType.friend,
    ),
    NotificationCardItem(
      title: 'Tournament Update',
      message: 'The Weekly Warrior tournament starts in 1 hour',
      timeAgo: '1h ago',
      isUnread: true,
      type: NotificationType.tournament,
    ),
    NotificationCardItem(
      title: 'Wallet Alert',
      message: 'You received ₦2,500 from a completed match',
      timeAgo: '2h ago',
      isUnread: true,
      type: NotificationType.wallet,
    ),
    NotificationCardItem(
      title: 'System Update',
      message: 'New season is live! Check out the rewards',
      timeAgo: '3h ago',
      isUnread: true,
      type: NotificationType.system,
    ),
  ];

  @override
Widget build(BuildContext context) {
  return AppBackground(
    child: Scaffold(
      backgroundColor: const Color.fromARGB(129, 9, 3, 4),
      appBar: const NotificationAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 8),

          NotificationFilter(
            selectedIndex: _selectedFilterIndex,
            onFilterSelected: (index) {
              setState(() {
                _selectedFilterIndex = index;
              });
            },
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _notifications.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final item = _notifications[index];

                return NotificationCard(
                  notification: item,
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
}