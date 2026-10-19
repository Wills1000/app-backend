import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'package:gamer_app/features/settings/presentation/pages/settings_screen.dart';
import 'package:gamer_app/features/feed/presentation/pages/post_view_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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