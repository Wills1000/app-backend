import 'package:flutter/material.dart';
import 'package:gamer_app/features/auth/presentation/otp_screen.dart';
import 'package:gamer_app/core/network/dio_client.dart';
import 'package:gamer_app/features/auth/repositories/auth_repository.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;
  bool _isLoading = false;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Instantiate the Auth Repository
  final AuthRepository _authRepository = AuthRepository(DioClient());

  static const _accentColor = Color(0xff970303);
  static const _surfaceColor = Color(0xff1B1B1B);

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.25,
      end: 0.55,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _glowController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms & Privacy Policy')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool success = await _authRepository.registerUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        username: _usernameController.text.trim(),
      );

      if (success && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OtpScreen(),
          ),
        );
      }
    } catch (e) {
      print('Signup error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration _fieldDecoration(
    String hint,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(
        icon,
        color: _accentColor,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: _surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// Top & Bottom Ambient Glows (Isolated rebuilds)
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: -170,
                    left: -140,
                    child: Container(
                      width: 340,
                      height: 340,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _accentColor.withOpacity(_glowAnimation.value),
                            blurRadius: 180,
                            spreadRadius: 55,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -170,
                    right: -140,
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _accentColor.withOpacity(_glowAnimation.value * 0.8),
                            blurRadius: 180,
                            spreadRadius: 55,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          /// Form Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  const SizedBox(height: 15),

                  Image.asset(
                    "assets/images/logo3.png",
                    width: 90,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Join thousands of gamers.\nCompete. Win. Earn.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// Form Container with Dynamic Card Glow
                  AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.75),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _accentColor.withOpacity(.25),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _accentColor.withOpacity(_glowAnimation.value * 0.35),
                              blurRadius: 50,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: child,
                      );
                    },
                    child: Column(
                      children: [
                        TextField(
                          controller: _usernameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _fieldDecoration(
                            "Username",
                            Icons.person_outline,
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: _fieldDecoration(
                            "Email Address",
                            Icons.email_outlined,
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: Colors.white),
                          decoration: _fieldDecoration(
                            "Phone Number",
                            Icons.phone_outlined,
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: _fieldDecoration(
                            "Password",
                            Icons.lock_outline,
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: _fieldDecoration(
                            "Confirm Password",
                            Icons.lock_outline,
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Row(
                          children: [
                            Checkbox(
                              value: _agreeTerms,
                              activeColor: _accentColor,
                              onChanged: (value) {
                                setState(() {
                                  _agreeTerms = value ?? false;
                                });
                              },
                            ),
                            const Expanded(
                              child: Text(
                                "I agree to the Terms & Privacy Policy",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// Create Account Button
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
                            onPressed: _isLoading ? null : _handleSignup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "CREATE ACCOUNT",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        Row(
                          children: const [
                            Expanded(child: Divider(color: Colors.white24)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "OR",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.2,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.white24)),
                          ],
                        ),

                        const SizedBox(height: 22),

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
                            onPressed: () {
                              // TODO: Integrate Google Sign-In SDK token retrieval here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(color: Colors.white60),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Log In",
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}