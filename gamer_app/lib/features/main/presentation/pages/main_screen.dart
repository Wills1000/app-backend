import 'package:flutter/material.dart';

import 'package:gamer_app/core/navigation/nav_controller.dart';
import 'package:gamer_app/core/navigation/nav_provider.dart';

import 'package:gamer_app/features/home/presentation/home_screen.dart';
import 'package:gamer_app/features/arena/presentation/pages/arena_screen.dart';
import 'package:gamer_app/features/feed/presentation/pages/feed_screen.dart';
import 'package:gamer_app/features/socials/presentation/pages/social_screen.dart';
import 'package:gamer_app/features/home/presentation/widgets/bottom_nav.dart';
import 'package:gamer_app/features/profile/presentation/pages/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final NavController navController = NavController();

  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    ArenaScreen(),
    FeedScreen(),
    SocialScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return NavProvider(
      controller: navController,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: IndexedStack(
                index: currentIndex,
                children: pages,
              ),
            ),

            AnimatedBuilder(
              animation: navController,
              builder: (context, child) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  left: 0,
                  right: 0,
                  bottom: navController.visible ? 0 : -110,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 220),
                    opacity: navController.visible ? 1 : 0,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutBack,
                      scale: navController.visible ? 1 : .96,
                      child: BottomNav(
                        selectedNavIndex: currentIndex,
                        onTap: (index) {
                          if (currentIndex == index) return;

                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                    ),
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