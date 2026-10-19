import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gamer_app/features/auth/presentation/complete_profile_screen.dart';

class OtpSuccessSheet extends StatelessWidget {
  const OtpSuccessSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(35),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15,
          sigmaY: 15,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(25, 35, 25, 35),
          decoration: BoxDecoration(
            color: const Color(0xff161616),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(35),
            ),
            border: Border.all(
              color: const Color(0xff970303).withOpacity(.30),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff970303).withOpacity(.25),
                blurRadius: 40,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xff970303).withOpacity(.15),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 65,
                    color: Color(0xff970303),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Verification Successful",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Your account has been verified successfully.\nLet's complete your profile.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xff970303),
                          Colors.black,
                          Color(0xff970303),
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const CompleteProfileScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "CONTINUE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}