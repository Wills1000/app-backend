import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:gamer_app/core/network/dio_client.dart';
import 'package:gamer_app/features/auth/repositories/auth_repository.dart';
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
  final AuthRepository _authRepo = AuthRepository(DioClient());
 
  Timer? _timer;
  int secondsRemaining = 60;
  bool canResend = false;
 
  bool showSuccessSheet = false;
  bool _isSending = false;
  bool _isVerifying = false;
 
  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
 
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }
 
  // Starts (or restarts) the resend countdown
  void startCountdown([int seconds = 60]) {
    _timer?.cancel();
 
    setState(() {
      secondsRemaining = seconds;
      canResend = seconds <= 0;
    });
 
    if (seconds <= 0) return;
 
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
 
      if (secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          secondsRemaining = 0;
          canResend = true;
        });
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }
 
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
 
  // Asks the backend to email a new 6-digit code
  Future<void> _sendCode() async {
    if (_isSending) return;
 
    setState(() {
      _isSending = true;
      canResend = false;
    });
 
    try {
      final result = await _authRepo.sendVerificationCode();
      if (!mounted) return;
 
      setState(() => _isSending = false);
 
      if (result.alreadyVerified) {
        setState(() => showSuccessSheet = true);
        return;
      }
 
      startCountdown(result.resendInSeconds);
      _showMessage("Verification code sent. Check your inbox and spam folder.");
    } on VerificationException catch (e) {
      if (!mounted) return;
      setState(() => _isSending = false);
 
      if (e.resendInSeconds != null) {
        // A code was sent a moment ago: just wait for the timer
        startCountdown(e.resendInSeconds!);
      } else {
        setState(() => canResend = true);
        _showMessage(e.message);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSending = false;
        canResend = true;
      });
      _showMessage("Could not send the code. Please try again.");
    }
  }
 
  // Checks the typed code with the backend
  Future<void> _verify(String pin) async {
    if (_isVerifying) return;
 
    if (pin.length != 6) {
      _showMessage("Please enter the complete verification code.");
      return;
    }
 
    _isVerifying = true;
 
    final ValueNotifier<bool> verified = ValueNotifier<bool>(false);
 
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _VerifyingCard(verified: verified),
    );
 
    try {
      await _authRepo.verifyCode(pin);
      if (!mounted) return;
 
      HapticFeedback.mediumImpact();
      verified.value = true; // the dialog switches to its success state
 
      await Future.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
 
      Navigator.pop(context); // close the dialog
      setState(() {
        showSuccessSheet = true;
      });
    } on VerificationException catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      otpController.clear();
      HapticFeedback.heavyImpact();
      _showMessage(e.message);
    } catch (_) {
      if (!mounted) return;
      Navigator.pop(context);
      otpController.clear();
      _showMessage("Something went wrong. Please try again.");
    } finally {
      _isVerifying = false;
    }
  }
 
  // Fades and slides a widget up when it first appears
  Widget _entrance({required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 40),
            child: child,
          ),
        );
      },
    );
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
 
    // Send the first code as soon as this screen opens
    _sendCode();
  }
 
  @override
  void dispose() {
    _timer?.cancel();
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
                        color: const Color(0xff970303).withOpacity(glow.value),
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
                        color: const Color(0xff970303).withOpacity(glow.value),
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
                        onCompleted: (pin) => _verify(pin),
                      ),
                      const SizedBox(height: 40),
                      _entrance(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: const Color(0xff050505),
                            borderRadius: BorderRadius.circular(35),
                            border: Border.all(
                              color: const Color(0xff970303).withOpacity(.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xff970303).withOpacity(.25),
                                blurRadius: 40,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "Didn't receive the verification code?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: canResend ? _sendCode : null,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      canResend
                                          ? Icons.refresh_rounded
                                          : Icons.timer_outlined,
                                      size: 18,
                                      color: canResend
                                          ? const Color(0xff970303)
                                          : Colors.white54,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _isSending
                                          ? "Sending code..."
                                          : canResend
                                              ? "Resend Code"
                                              : "Resend in ${formatTime(secondsRemaining)}",
                                      style: TextStyle(
                                        color: canResend
                                            ? const Color(0xff970303)
                                            : Colors.white54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 22),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white.withOpacity(.03),
                                    side: BorderSide(
                                      color: const Color(0xff970303).withOpacity(.6),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Text(
                                    "CHANGE EMAIL",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                  child: _entrance(
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
                          color: const Color(0xff970303).withOpacity(.25),
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
                              color: const Color(0xff970303).withOpacity(.15),
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
                ),
            ],
          );
        },
      ),
    );
  }
}
 
 
// The card shown while the code is being checked.
// It switches to a check mark when the code is correct.
class _VerifyingCard extends StatelessWidget {
  final ValueNotifier<bool> verified;
 
  const _VerifyingCard({required this.verified});
 
  @override
  Widget build(BuildContext context) {
    return Center(
      // Material removes the yellow underline that plain Text gets inside dialogs
      child: Material(
        type: MaterialType.transparency,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.85, end: 1),
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Opacity(
              opacity: scale.clamp(0.0, 1.0).toDouble(),
              child: Transform.scale(scale: scale, child: child),
            );
          },
          child: Container(
            width: 230,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            decoration: BoxDecoration(
              color: const Color(0xff050505),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xff970303).withOpacity(.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff970303).withOpacity(.25),
                  blurRadius: 40,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: ValueListenableBuilder<bool>(
              valueListenable: verified,
              builder: (context, isVerified, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 56,
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: isVerified
                              ? TweenAnimationBuilder<double>(
                                  key: const ValueKey('done'),
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration: const Duration(milliseconds: 550),
                                  curve: Curves.elasticOut,
                                  builder: (context, value, _) {
                                    return Transform.scale(
                                      scale: value,
                                      child: const Icon(
                                        Icons.check_circle,
                                        color: Color(0xff970303),
                                        size: 56,
                                      ),
                                    );
                                  },
                                )
                              : const KeyedSubtree(
                                  key: ValueKey('loading'),
                                  child: LoadingDots(),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        isVerified ? "Verified!" : "Verifying...",
                        key: ValueKey<bool>(isVerified),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
 