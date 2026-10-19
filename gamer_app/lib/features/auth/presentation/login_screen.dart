import 'package:flutter/material.dart';
import 'package:gamer_app/features/auth/presentation/signup_screen.dart';
import 'package:gamer_app/features/main/presentation/pages/main_screen.dart';
import 'package:gamer_app/core/network/dio_client.dart';
import 'package:gamer_app/features/auth/repositories/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository(DioClient());
  bool _isLoading = false;

  bool _rememberMe = false;
  bool _obscurePassword = true;

  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  static const _accentColor = Color(0xff970303);
  static const _surfaceColor = Color(0xff1B1B1B);

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.25, end: 0.55).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050505),
      body: Stack(
        children: [
          /// Top & Bottom Ambient Glows (Animated isolated from main UI)
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: -120,
                    left: -120,
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _accentColor.withOpacity(
                              _glowAnimation.value,
                            ),
                            blurRadius: 180,
                            spreadRadius: 70,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -120,
                    right: -120,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _accentColor.withOpacity(
                              _glowAnimation.value * 0.8,
                            ),
                            blurRadius: 180,
                            spreadRadius: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          /// Form Body
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Image.asset("assets/images/logo3.png", width: 90),

                  const SizedBox(height: 25),

                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Log in to continue your gaming journey.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),

                  const SizedBox(height: 20),

                  /// Card Wrapper
                  AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.75),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: _accentColor.withOpacity(.25),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _accentColor.withOpacity(
                                _glowAnimation.value * .35,
                              ),
                              blurRadius: 50,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: child,
                      );
                    },
                    child: Column(
                      children: [
                        /// Email Input
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: _accentColor,
                            ),
                            hintText: "Enter your email",
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: _surfaceColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// Password Input
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: _accentColor,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white54,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            hintText: "Enter your password",
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: _surfaceColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// Remember Me & Forgot Password
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              activeColor: _accentColor,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                            const Expanded(
                              child: Text(
                                "Remember Me",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgot?",
                                style: TextStyle(
                                  color: _accentColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        /// Login Button
                        Container(
                          width: double.infinity,
                          height: 48,
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: _isLoading ? null : () async {
      setState(() => _isLoading = true);
      
      try {
        // This hits your NestJS backend /auth/sync endpoint!
        bool success = await _authRepository.authenticateUser(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (success && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MainScreen(),
            ),
          );
        }
      } catch (e) {
        print('Login failed: $e');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    },
    child: _isLoading 
      ? const SizedBox(
          height: 20, 
          width: 20, 
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        )
      : const Text(
          "LOG IN",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        const Text(
                          "OR CONTINUE WITH",
                          style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// Google Button
                        Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            color: _surfaceColor,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.g_mobiledata,
                              color: Colors.white,
                              size: 32,
                            ),
                            label: const Text(
                              "Continue with Google",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// Navigation to Signup
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(color: Colors.white60),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: _accentColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
