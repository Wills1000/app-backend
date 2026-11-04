import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_picker/country_picker.dart';
import 'package:gamer_app/core/network/dio_client.dart';
import 'package:gamer_app/features/auth/presentation/bio_screen.dart';
import 'package:gamer_app/features/auth/repositories/profile_repository.dart';
 
class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});
 
  @override
  State<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}
 
class _CompleteProfileScreenState
    extends State<CompleteProfileScreen>
    with SingleTickerProviderStateMixin {
 
  late AnimationController _controller;
  late Animation<double> glow;
 
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();
  final countryController = TextEditingController();
 
  final ProfileRepository _profileRepo = ProfileRepository(DioClient());
 
  // Every picture inside assets/avatars/ shows up here automatically
  List<String> _avatars = ['assets/avatars/ava1.jpg'];
  String _selectedAvatar = 'assets/avatars/ava1.jpg';
 
  DateTime? dob;
  bool _isSaving = false;
 
  String? gender;
  String? country; // plain country name, e.g. "Nigeria"
  String? state;
  String? city;
  String? language;
 
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
 
    _loadAvatars();
  }
 
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    countryController.dispose();
 
    _controller.dispose();
 
    super.dispose();
  }
 
  InputDecoration inputStyle(
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white54,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xff970303),
      ),
      filled: true,
      fillColor: const Color(0xff1B1B1B),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: Color(0xff970303),
          width: 2,
        ),
      ),
    );
  }
 
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
 
  // ---------------------------------------------------------------------------
  // Avatars
  // ---------------------------------------------------------------------------
 
  // Finds every picture in assets/avatars/ (ava1.jpg, ava2.png, ...)
  Future<void> _loadAvatars() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
 
      int numberIn(String path) {
        final match = RegExp(r'\d+').firstMatch(path.split('/').last);
        return int.tryParse(match?.group(0) ?? '') ?? 0;
      }
 
      final found = manifest
          .listAssets()
          .where((path) =>
              path.startsWith('assets/avatars/') &&
              RegExp(r'\.(png|jpe?g|webp)$', caseSensitive: false)
                  .hasMatch(path))
          .toList()
        ..sort((a, b) {
          final byNumber = numberIn(a).compareTo(numberIn(b));
          return byNumber != 0 ? byNumber : a.compareTo(b);
        });
 
      if (!mounted || found.isEmpty) return;
 
      setState(() {
        _avatars = found;
        if (!found.contains(_selectedAvatar)) {
          _selectedAvatar = found.first;
        }
      });
    } catch (_) {
      // Keep the default avatar if the list can't be read
    }
  }
 
  Widget _avatarThumb(String path) {
    final selected = path == _selectedAvatar;
 
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedAvatar = path;
        });
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: selected ? 1 : .6,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 72,
          height: 72,
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? const Color(0xff970303) : Colors.white12,
              width: selected ? 2.5 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: const Color(0xff970303).withOpacity(.45),
                      blurRadius: 14,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: ClipOval(
            child: Image.asset(
              path,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
 
  // ---------------------------------------------------------------------------
  // Date of birth
  // ---------------------------------------------------------------------------
 
  String _two(int n) => n.toString().padLeft(2, '0');
 
  String _formatDate(DateTime d) => "${_two(d.day)}/${_two(d.month)}/${d.year}";
 
  String _isoDate(DateTime d) => "${d.year}-${_two(d.month)}-${_two(d.day)}";
 
  Future<void> _pickDob() async {
    final now = DateTime.now();
    // Must be at least 18 years old
    final latest = DateTime(now.year - 18, now.month, now.day);
 
    final picked = await showDatePicker(
      context: context,
      initialDate: dob ?? latest,
      firstDate: DateTime(1940),
      lastDate: latest,
      helpText: "Date of birth",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xff970303),
              onPrimary: Colors.white,
              surface: Color(0xff1B1B1B),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
 
    if (picked != null) {
      setState(() {
        dob = picked;
        dobController.text = _formatDate(picked);
      });
    }
  }
 
  // ---------------------------------------------------------------------------
  // Saving
  // ---------------------------------------------------------------------------
 
  String? _validate() {
    if (firstNameController.text.trim().isEmpty) {
      return "Please enter your first name.";
    }
    if (lastNameController.text.trim().isEmpty) {
      return "Please enter your last name.";
    }
    if (dob == null) {
      return "Please select your date of birth.";
    }
    if (gender == null) {
      return "Please select your gender.";
    }
    if (country == null) {
      return "Please select your country.";
    }
    return null;
  }
 
  Future<void> _saveAndContinue() async {
    if (_isSaving) return;
 
    FocusScope.of(context).unfocus();
 
    final error = _validate();
    if (error != null) {
      _showMessage(error);
      return;
    }
 
    setState(() {
      _isSaving = true;
    });
 
    try {
      await _profileRepo.updateProfile({
        'avatarUrl': _selectedAvatar,
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'dateOfBirth': _isoDate(dob!),
        'gender': gender == "Male" ? "MALE" : "FEMALE",
        'country': country,
        if (state != null) 'state': state,
        if (city != null) 'city': city,
        if (language != null) 'language': language,
      });
 
      if (!mounted) return;
 
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BioScreen(),
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
 
  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050505),
      body: AnimatedBuilder(
        animation: glow,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned(
                top: -180,
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
                bottom: -180,
                right: -150,
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
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 25,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Complete Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Let's get to know you.",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.75),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color(0xff970303).withOpacity(.25),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff970303).withOpacity(
                                glow.value * .35,
                              ),
                              blurRadius: 50,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Choose Avatar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
 
                            // Big preview of the chosen avatar
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Container(
                                key: ValueKey(_selectedAvatar),
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xff970303),
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    _selectedAvatar,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
 
                            // Pick one from the avatars we have
                            SizedBox(
                              height: 82,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _avatars.length,
                                itemBuilder: (context, index) {
                                  return _avatarThumb(_avatars[index]);
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
 
                            TextField(
                              controller: firstNameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: inputStyle(
                                "First Name",
                                Icons.badge_outlined,
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextField(
                              controller: lastNameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: inputStyle(
                                "Last Name",
                                Icons.badge_outlined,
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextField(
                              controller: dobController,
                              readOnly: true,
                              onTap: _pickDob,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: inputStyle(
                                "Date of Birth",
                                Icons.calendar_month_outlined,
                              ),
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField<String>(
                              value: gender,
                              dropdownColor: const Color(0xff1B1B1B),
                              style: const TextStyle(color: Colors.white),
                              decoration: inputStyle(
                                "Gender",
                                Icons.person,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: "Male",
                                  child: Text("Male"),
                                ),
                                DropdownMenuItem(
                                  value: "Female",
                                  child: Text("Female"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  gender = value;
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            GestureDetector(
                              onTap: () {
                                showCountryPicker(
                                  context: context,
                                  showPhoneCode: false,
                                  countryListTheme: CountryListThemeData(
                                    backgroundColor: const Color(0xff1B1B1B),
                                    borderRadius: BorderRadius.circular(20),
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    inputDecoration: const InputDecoration(
                                      hintText: "Search Country",
                                      prefixIcon: Icon(Icons.search),
                                    ),
                                  ),
                                  onSelect: (Country value) {
                                    setState(() {
                                      country = value.name;
                                      countryController.text =
                                          "${value.flagEmoji} ${value.name}";
                                    });
                                  },
                                );
                              },
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: countryController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: inputStyle(
                                    "Country",
                                    Icons.public,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField<String>(
                              value: state,
                              dropdownColor: const Color(0xff1B1B1B),
                              style: const TextStyle(color: Colors.white),
                              decoration: inputStyle(
                                "State / Province",
                                Icons.location_city_outlined,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: "Rivers",
                                  child: Text("Rivers"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  state = value;
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField<String>(
                              value: city,
                              dropdownColor: const Color(0xff1B1B1B),
                              style: const TextStyle(color: Colors.white),
                              decoration: inputStyle(
                                "City",
                                Icons.location_on_outlined,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: "Port Harcourt",
                                  child: Text("Port Harcourt"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  city = value;
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField<String>(
                              value: language,
                              dropdownColor: const Color(0xff1B1B1B),
                              style: const TextStyle(color: Colors.white),
                              decoration: inputStyle(
                                "Language",
                                Icons.language,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: "English",
                                  child: Text("English"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  language = value;
                                });
                              },
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
                                  onPressed: _isSaving ? null : _saveAndContinue,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
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
            ],
          );
        },
      ),
    );
  }
}
 