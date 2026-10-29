import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // <-- Add this import

import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'package:gamer_app/features/settings/presentation/pages/settings_screen.dart';
import 'package:gamer_app/features/feed/presentation/pages/post_view_screen.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  // Initialize Firebase with your generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
 
  runApp(const GamerApp());
}
 
class GamerApp extends StatelessWidget {
  const GamerApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gamer App',
      theme: AppTheme.darkTheme,
      routes: {
        SettingsScreen.routeName: (_) => const SettingsScreen(),
      },
      home: const OnboardingScreen(),
    );
  }
}