import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gamer_app/shared/widgets/swipe_button.dart';
import 'package:gamer_app/features/auth/presentation/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  int currentPage = 0;
  Timer? timer;

  final List<Map<String, String>> pages = [
    {
      "image": "assets/images/r1.png",
      "title": "FIND PLAYERS",
      "subtitle":
          "Connect with gamers who play your favourite games. Find teammates or opponents anytime, anywhere.",
    },
    {
      "image": "assets/images/cod2.jpg",
      "title": "COMPETE",
      "subtitle":
          "Join exciting challenges, test your skills against real players, and climb the leaderboard.",
    },
    {
      "image": "assets/images/gta1.jpg",
      "title": "EARN REAL CASH",
      "subtitle":
          "Win eligible matches, earn real cash, and turn your gaming skills into rewards.",
    },
  ];

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (!_controller.hasClients) return;

      if (currentPage < pages.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      _controller.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090312),
      body: Stack(
        children: [

          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {

              return Stack(
                fit: StackFit.expand,
                children: [

                  Image.asset(
                    pages[index]["image"]!,
                    fit: BoxFit.cover,
                  ),

                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color.fromARGB(233, 0, 0, 0),
                          Color.fromARGB(255, 0, 0, 0),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Spacer(),

                        Row(
                          children: List.generate(
                            pages.length,
                            (dot) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(right: 6),
                              width: currentPage == dot ? 26 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: currentPage == dot
                                    ? const Color.fromARGB(255, 151, 3, 3)
                                    : Colors.white30,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Text(
                          pages[index]["title"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          pages[index]["subtitle"]!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 40),

                        SwipeButton(
  onCompleted: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  },
),
                        const SizedBox(height: 30),

                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          Positioned(
            top: 55,
            right: 20,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "Skip",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}