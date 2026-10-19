import 'package:flutter/material.dart';
import 'package:gamer_app/features/main/presentation/pages/main_screen.dart';

class BioScreen extends StatefulWidget {
  const BioScreen({super.key});

  @override
  State<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen>
    with SingleTickerProviderStateMixin {
  final _bioController = TextEditingController();

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

    _glowAnimation = Tween<double>(
      begin: 0.25,
      end: 0.55,
    ).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050505),

      body: Stack(
        children: [

          /// Animated Background Glow
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
                              _glowAnimation.value * .8,
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

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),

              child: Column(
                children: [

                  const SizedBox(height: 20),

                  Image.asset(
                    "assets/images/logo3.png",
                    width: 90,
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Complete Your Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Tell other gamers who you are.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 20),

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
                                                /// Bio Input
                        TextField(
                          controller: _bioController,
                          maxLines: 6,
                          maxLength: 180,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 95),
                              child: Icon(
                                Icons.person_outline,
                                color: _accentColor,
                              ),
                            ),
                            hintText:
                                "Legendary COD player 🎯\n"
                                "Looking for competitive teammates.\n"
                                "Usually online after 7 PM.",
                            hintStyle: const TextStyle(
                              color: Colors.white54,
                              height: 1.5,
                            ),
                            filled: true,
                            fillColor: _surfaceColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            counterStyle: const TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Quick Bio",
                            style: TextStyle(
                              color: Colors.white.withOpacity(.85),
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [

                            _buildChip("🏆 Competitive"),

                            _buildChip("🎮 Casual"),

                            _buildChip("🤝 Looking for Team"),

                            _buildChip("🔥 Tournament Player"),

                            _buildChip("🎥 Content Creator"),

                            _buildChip("🥇 Top Ranked"),

                          ],
                        ),

                        const SizedBox(height: 25),

                        /// Continue Button
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

                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MainScreen(),
                                ),
                              );
                            },

                            child: const Text(
                              "CONTINUE",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),
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

  Widget _buildChip(String text) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        if (_bioController.text.isEmpty) {
          _bioController.text = text;
        } else {
          _bioController.text += " • $text";
        }

        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: _accentColor.withOpacity(.35),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}