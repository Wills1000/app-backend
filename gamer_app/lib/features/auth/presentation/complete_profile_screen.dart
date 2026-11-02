import 'dart:io';
 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
 
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();
  final countryController = TextEditingController();
 
  final ImagePicker _picker = ImagePicker();
  final ProfileRepository _profileRepo = ProfileRepository(DioClient());
 
  File? _avatarFile; // the photo the user picked (null = default avatar)
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
  }
 
  @override
  void dispose() {
    usernameController.dispose();
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
  // Avatar
  // ---------------------------------------------------------------------------
 
  Future<void> _pickAvatar(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked == null) return;
 
      setState(() {
        _avatarFile = File(picked.path);
      });
    } catch (_) {
      _showMessage(
        source == ImageSource.camera
            ? "Could not open the camera. Please check the app's camera permission."
            : "Could not open your gallery. Please check the app's photo permission.",
      );
    }
  }
 
  Widget _avatarOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xff970303).withOpacity(.15),
        ),
        child: Icon(icon, color: const Color(0xff970303)),
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
 
  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
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
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Profile Photo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _avatarOption(
                  icon: Icons.photo_library_outlined,
                  label: "Choose from gallery",
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickAvatar(ImageSource.gallery);
                  },
                ),
                _avatarOption(
                  icon: Icons.camera_alt_outlined,
                  label: "Take a photo",
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickAvatar(ImageSource.camera);
                  },
                ),
                if (_avatarFile != null)
                  _avatarOption(
                    icon: Icons.delete_outline,
                    label: "Remove photo",
                    onTap: () {
                      Navigator.pop(sheetContext);
                      setState(() {
                        _avatarFile = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
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
    final username = usernameController.text.trim();
 
    if (!RegExp(r'^[a-zA-Z0-9_]{3,20}$').hasMatch(username)) {
      return "Username must be 3-20 characters: letters, numbers or underscore.";
    }
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
 
  String _genderToApi(String value) {
    switch (value) {
      case "Male":
        return "MALE";
      case "Female":
        return "FEMALE";
      case "Other":
        return "OTHER";
      default:
        return "PREFER_NOT_TO_SAY";
    }
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
      // Details first (this also checks that the username is free)
      await _profileRepo.updateProfile({
        'username': usernameController.text.trim(),
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'dateOfBirth': _isoDate(dob!),
        'gender': _genderToApi(gender!),
        'country': country,
        if (state != null) 'state': state,
        if (city != null) 'city': city,
        if (language != null) 'language': language,
      });
 
      // Then the photo, if one was picked
      if (_avatarFile != null) {
        await _profileRepo.uploadAvatar(_avatarFile!);
      }
 
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
                            GestureDetector(
                              onTap: _showAvatarOptions,
                              child: Stack(
                                children: [
                                  Container(
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
                                      child: _avatarFile != null
                                          ? Image.file(
                                              _avatarFile!,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              "assets/avatars/ava1.jpg",
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xff970303),
                                        border: Border.all(
                                          color: const Color(0xff050505),
                                          width: 3,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: _showAvatarOptions,
                              child: const Text(
                                "Change Avatar",
                                style: TextStyle(
                                  color: Color(0xff970303),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextField(
                              controller: usernameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: inputStyle(
                                "Username",
                                Icons.person_outline,
                              ),
                            ),
                            const SizedBox(height: 15),
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
                                DropdownMenuItem(
                                  value: "Other",
                                  child: Text("Other"),
                                ),
                                DropdownMenuItem(
                                  value: "Prefer not to say",
                                  child: Text("Prefer not to say"),
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
 