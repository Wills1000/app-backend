import 'package:flutter/material.dart';
import 'package:gamer_app/core/network/dio_client.dart';
import 'package:gamer_app/features/auth/repositories/profile_repository.dart';
import 'package:gamer_app/features/main/presentation/pages/main_screen.dart';
 
class BioScreen extends StatefulWidget {
  const BioScreen({super.key});
 
  @override
  State<BioScreen> createState() => _BioScreenState();
}
 
class _BioScreenState extends State<BioScreen>
    with SingleTickerProviderStateMixin {
  final _bioController = TextEditingController();
  final ProfileRepository _profileRepo = ProfileRepository(DioClient());
 
  // The quick-bio chips the user has tapped
  final Set<String> _selectedTags = {};
  bool _isSaving = false;
 
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;
 
  static const _accentColor = Color(0xff970303);
  static const _surfaceColor = Color(0xff1B1B1B);
  static const _maxBioLength = 180;
 
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
 
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
 
  // Sets the bio text and keeps the cursor at the end
  void _setBio(String text) {
    _bioController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
 
  // Tap a chip to add it to the bio, tap again to remove it
  void _toggleChip(String text) {
    final current = _bioController.text;
 
    if (_selectedTags.contains(text)) {
      var updated = current.replaceFirst(" • $text", "");
      if (updated == current) updated = current.replaceFirst("$text • ", "");
      if (updated == current) updated = current.replaceFirst(text, "");
 
      _setBio(updated.trim());
      _selectedTags.remove(text);
    } else {
      final next = current.isEmpty ? text : "$current • $text";
 
      if (next.length > _maxBioLength) {
        _showMessage("Your bio is too long to add this.");
        return;
      }
 
      _setBio(next);
      _selectedTags.add(text);
    }
 
    setState(() {});
  }
 
  Future<void> _saveAndContinue() async {
    if (_isSaving) return;
 
    FocusScope.of(context).unfocus();
 
    final bio = _bioController.text.trim();
    // Only keep chips that are still part of the bio text
    final tags = _selectedTags.where((t) => bio.contains(t)).toList();
 
    setState(() {
      _isSaving = true;
    });
 
    try {
      // Nothing to save if the user skipped the bio
      if (bio.isNotEmpty || tags.isNotEmpty) {
        await _profileRepo.updateProfile({
          'bio': bio,
          'quickTags': tags,
        });
      }
 
      if (!mounted) return;
 
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainScreen(),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      _showMessage(e.message);
    } catch (_) {
      if (!mounted) return;
      _showMessage("Something went wrong. Please try again.");
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
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
                          maxLength: _maxBioLength,
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
                            hintText: "Legendary COD player 🎯\n"
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
                            onPressed: _isSaving ? null : _saveAndContinue,
                            child: _isSaving
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
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
    final selected = _selectedTags.contains(text);
 
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () => _toggleChip(text),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected ? _accentColor.withOpacity(.25) : _surfaceColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? _accentColor : _accentColor.withOpacity(.35),
            width: selected ? 1.5 : 1,
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
 