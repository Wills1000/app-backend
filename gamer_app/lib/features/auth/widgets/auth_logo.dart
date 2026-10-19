import 'package:flutter/material.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // Logo
        Container(
          width: 95,
          height: 95,
          decoration: BoxDecoration(
            color: const Color(0xff1A1228),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xffFF2D55),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.sports_esports_rounded,
            color: Color(0xffFF2D55),
            size: 50,
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          "Welcome Back",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          "Log in to continue your gaming journey",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white60,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}