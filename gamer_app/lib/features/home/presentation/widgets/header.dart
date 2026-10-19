import 'package:flutter/material.dart';
import 'package:gamer_app/shared/widgets/notification_button.dart';
import 'package:gamer_app/shared/widgets/support_button.dart';
import 'package:gamer_app/features/arena/presentation/pages/arena_screen.dart';
import 'package:gamer_app/features/profile/presentation/pages/profile_screen.dart';
import 'package:gamer_app/features/wallet/presentation/pages/wallet_screen.dart';
import 'package:gamer_app/features/search/presentation/pages/search_screen.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
    children: [

      /// Top Row
      Row(
        children: [

          Image.asset(
            'assets/images/logo3.png',
            width: 42,
            height: 42,
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Good Evening,",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  "Alex",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),

      const SupportButton(),
    const SizedBox(width: 2),
  const NotificationButton(),


        ],
      ),

      const SizedBox(height: 16),

      /// Bottom Row
      Row(
        children: [

          Expanded(
  child: InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const SearchScreen(),
    ),
  );
},
    child: Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xff160B0E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          SizedBox(width: 15),
          Icon(
            Icons.search,
            color: Colors.white54,
          ),
          SizedBox(width: 10),
          Text(
            "Search games...",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
    ),
  ),
),

          const SizedBox(width: 12),

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xff160B0E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const WalletScreen(),
      ),
    );
  },
              icon: const Icon(
  Icons.account_balance_wallet_rounded,
  color: Colors.white,
),
            ),
          ),

          const SizedBox(width: 12),

          GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfileScreen(),
      ),
    );
  },
  child: const CircleAvatar(
    radius: 22,
    backgroundColor: Color(0xff970303),
    child: Icon(
      Icons.person,
      color: Colors.white,
    ),
  ),
),

        ],
      ),

    ],
  );
  }
}