import 'package:flutter/material.dart';
import 'package:gamer_app/features/auth/presentation/bio_screen.dart';
import 'package:country_picker/country_picker.dart';

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

  String? gender;
  String? country;
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
                bottom: -180,
                right: -150,

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

                                child: Image.asset(
                                  "assets/avatars/ava1.jpg",
                                  fit: BoxFit.cover,
                                ),

                              ),
                            ),

                            const SizedBox(height: 8),

                            TextButton(

                              onPressed: () {},

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

                              style: const TextStyle(
                                  color: Colors.white),

                              decoration: inputStyle(
                                "Username",
                                Icons.person_outline,
                              ),
                            ),

                            const SizedBox(height: 15),

                            TextField(

                              controller: firstNameController,

                              style: const TextStyle(
                                  color: Colors.white),

                              decoration: inputStyle(
                                "First Name",
                                Icons.badge_outlined,
                              ),
                            ),

                            const SizedBox(height: 15),

                            TextField(

                              controller: lastNameController,

                              style: const TextStyle(
                                  color: Colors.white),

                              decoration: inputStyle(
                                "Last Name",
                                Icons.badge_outlined,
                              ),
                            ),

                                                        const SizedBox(height: 15),

                            TextField(
                              controller: dobController,
                              readOnly: true,
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
          country = "${value.flagEmoji} ${value.name}";
        });
      },
    );
  },
  child: AbsorbPointer(
    child: TextField(
      controller: TextEditingController(text: country ?? ""),
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
                                  borderRadius:
                                      BorderRadius.circular(15),
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
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const BioScreen(),
    ),
  );
},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Text(
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