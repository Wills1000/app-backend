import 'package:flutter/material.dart';

enum NotificationType { challenge, match, friend, tournament, wallet, system }

class NotificationCardItem {
  final String title;
  final String message;
  final String timeAgo;
  final bool isUnread;
  final NotificationType type;

  const NotificationCardItem({
    required this.title,
    required this.message,
    required this.timeAgo,
    this.isUnread = true,
    required this.type,
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationCardItem notification;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  static const Color primaryRed = Color(0xFF970303);
  static const Color cardBg = Color(0xFF141416);

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.challenge:
        return Icons.sports_mma_rounded;
      case NotificationType.match:
        return Icons.sports_esports;
      case NotificationType.friend:
        return Icons.person_add_alt_1;
      case NotificationType.tournament:
        return Icons.emoji_events;
      case NotificationType.wallet:
        return Icons.account_balance_wallet;
      case NotificationType.system:
        return Icons.settings;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Material(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Glowing Circular Icon Container
                Container(
                  width: 52,
                  height: 52,
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
                    _getIcon(notification.type),
                    color: primaryRed,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),

                // Content Details Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              notification.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            notification.timeAgo,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Red Unread Dot Indicator
                if (notification.isUnread) ...[
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}