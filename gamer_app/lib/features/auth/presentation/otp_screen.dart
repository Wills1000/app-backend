import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:gamer_app/features/auth/presentation/complete_profile_screen.dart';
import 'package:gamer_app/shared/widgets/loading_dots.dart';
// import 'package:shake/shake.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> glow;

  final TextEditingController otpController = TextEditingController();
  int secondsRemaining = 60;
bool canResend = false;

bool showSuccessSheet = false;

String formatTime(int seconds) {
  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;

  return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
}

void startCountdown() {
  Timer.periodic(const Duration(seconds: 1), (timer) {

    if (!mounted) {
      timer.cancel();
      return;
    }

    if (secondsRemaining == 0) {

      timer.cancel();

      setState(() {
        canResend = true;
      });

    } else {

      setState(() {
        secondsRemaining--;
      });

    }

  });
}

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    glow = Tween<double>(
      begin: .25,
      end: .55,
    ).animate(_controller);

    startCountdown();
  }

  @override
  void dispose() {
    otpController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final defaultPinTheme = PinTheme(
      width: 55,
      height: 60,

      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),

      decoration: BoxDecoration(
        color: const Color(0xff171717),
        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Colors.white10,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: const Color(0xff970303),
        width: 2,
      ),

      boxShadow: [
        BoxShadow(
          color: const Color(0xff970303).withOpacity(.35),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.black,

      body: AnimatedBuilder(
        animation: glow,

        builder: (context, child) {

          return Stack(
            children: [
              

              Positioned(
                top: -170,
                left: -150,

                child: Container(
                  width: 350,
                  height: 350,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    boxShadow: [

                      BoxShadow(
                        color: const Color(0xff970303)
                            .withOpacity(glow.value),

                        blurRadius: 180,
                        spreadRadius: 70,
                      ),

                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: -170,
                right: -150,

                child: Container(
                  width: 330,
                  height: 330,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    boxShadow: [

                      BoxShadow(
                        color: const Color(0xff970303)
                            .withOpacity(glow.value),

                        blurRadius: 180,
                        spreadRadius: 70,
                      ),

                    ],
                  ),
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),

                  child: Column(
                    children: [

                      const SizedBox(height: 30),

                      Image.asset(
                        "assets/images/otp.png",
                        height: 220,
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        "Verify Your Email",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "We've sent a verification code to your email address.",
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 45),

                      Pinput(
  controller: otpController,
  length: 6,

  defaultPinTheme: defaultPinTheme,
  focusedPinTheme: focusedPinTheme,
  submittedPinTheme: focusedPinTheme,

  onCompleted: (pin) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
  child: Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 35,
      vertical: 30,
    ),

    decoration: BoxDecoration(
      color: const Color(0xff171717),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(
        color: const Color(0xff970303).withOpacity(.2),
      ),
    ),

    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        const LoadingDots(),

        const SizedBox(height: 20),

        const Text(
          "Verifying...",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

      ],
    ),
  ),
),
    );

    await Future.delayed(const Duration(seconds: 2));

    Navigator.pop(context);

   if (pin == "123456") {

  setState(() {
    showSuccessSheet = true;
  });

}

else {
      otpController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid verification code"),
        ),
      );
    }
  },
),

                      const SizedBox(height: 40),

Container(
  padding: const EdgeInsets.all(22),

  decoration: BoxDecoration(
    color: Colors.white.withOpacity(.05),

    borderRadius: BorderRadius.circular(28),

    border: Border.all(
      color: Colors.white10,
    ),

    boxShadow: [
      BoxShadow(
        color: const Color(0xff970303).withOpacity(.15),
        blurRadius: 35,
        spreadRadius: 2,
      ),
    ],
  ),

  child: Column(
    children: [

      SizedBox(
        width: double.infinity,
        height: 55,

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

              if (otpController.text.length != 6) {

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Please enter the complete verification code.",
                    ),
                  ),
                );

                return;
              }

              // TODO:
              // Navigate to Complete Profile Screen

            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),

            child: const Text(
              "VERIFY CODE",

              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),

      const SizedBox(height: 25),

      const Text(
        "Didn't receive the verification code?",

        style: TextStyle(
          color: Colors.white60,
        ),
      ),

      TextButton(
  onPressed: canResend
      ? () {
          setState(() {
            secondsRemaining = 60;
            canResend = false;
          });

          startCountdown();

          // TODO:
          // Call your resend OTP function here
        }
      : null,

  child: Text(
    canResend
        ? "Resend Code"
        : "Resend in ${formatTime(secondsRemaining)}",

    style: TextStyle(
      color: canResend
          ? const Color(0xff970303)
          : Colors.white54,

      fontWeight: FontWeight.bold,
    ),
  ),
),

      const SizedBox(height: 10),

      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },

        child: const Text(
          "Change Email",

          style: TextStyle(
            color: Colors.white54,
          ),
        ),
      ),

    ],
  ),
),

const SizedBox(height: 30),

                    ],
                  ),
                ),
              ),
              if (showSuccessSheet)
  Positioned.fill(
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 12,
        sigmaY: 12,
      ),
      child: Container(
        color: Colors.black.withOpacity(.35),
      ),
    ),
  ),

if (showSuccessSheet)
  Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      padding: const EdgeInsets.all(28),

      decoration: BoxDecoration(
        color: const Color(0xff050505),

        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(35),
        ),

        border: Border.all(
          color: const Color(0xff970303).withOpacity(.3),
        ),

        boxShadow: [
          BoxShadow(
            color: const Color(0xff970303)
                .withOpacity(.25),
            blurRadius: 40,
            spreadRadius: 3,
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
                color: const Color(0xff970303)
                    .withOpacity(.15),
              ),

              child: const Icon(
                Icons.check_circle,
                color: Color(0xff970303),
                size: 65,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Account Verified",

              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Welcome to Gamer App.\nYou're ready to compete and earn real cash.",

              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.white60,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
  width: double.infinity,
  height: 48,
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const CompleteProfileScreen(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: const Text(
        "CONTINUE",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 1.2,
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
            ],
          );
        },
      ),
    );
  }
}