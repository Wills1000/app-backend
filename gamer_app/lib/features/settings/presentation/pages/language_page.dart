import 'package:flutter/material.dart';
import '../widgets/settings_section.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String selectedLanguage = 'English';

  final languages = ['English', 'Spanish', 'French', 'German', 'Chinese', 'Japanese'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Language', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        children: [
          SettingsSection(
            children: languages.map((lang) {
              final isSelected = lang == selectedLanguage;
              return ListTile(
                title: Text(lang, style: const TextStyle(color: Colors.white, fontSize: 15)),
                trailing: isSelected
                    ? const Icon(Icons.check_circle_rounded, color: Color(0xFFFF3333))
                    : null,
                onTap: () => setState(() => selectedLanguage = lang),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}