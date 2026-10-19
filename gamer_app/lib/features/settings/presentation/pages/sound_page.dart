import 'package:flutter/material.dart';
import '../widgets/settings_switch_tile.dart';
import '../widgets/settings_section.dart';

class SoundPage extends StatefulWidget {
  const SoundPage({super.key});

  @override
  State<SoundPage> createState() => _SoundPageState();
}

class _SoundPageState extends State<SoundPage> {
  // Volume slider values (0.0 to 1.0)
  double masterVolume = 0.75;
  double effectsVolume = 0.60;
  double voiceChatVolume = 0.85;
  double musicVolume = 0.70;

  // Toggle states
  bool enableVibration = true;
  bool hapticFeedback = true;

  static const Color primaryRed = Color(0xFF970303);
  static const Color accentRed = Color(0xFFFF3333);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Sounds & Vibration',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        physics: const BouncingScrollPhysics(),
        children: [
          // Volume Sliders Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF101012),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVolumeSlider(
                  label: 'Master Volume',
                  icon: Icons.volume_up_rounded,
                  value: masterVolume,
                  onChanged: (val) => setState(() => masterVolume = val),
                ),
                const Divider(color: Colors.white10, height: 24),
                _buildVolumeSlider(
                  label: 'Effects',
                  icon: Icons.sports_esports_rounded,
                  value: effectsVolume,
                  onChanged: (val) => setState(() => effectsVolume = val),
                ),
                const Divider(color: Colors.white10, height: 24),
                _buildVolumeSlider(
                  label: 'Voice Chat',
                  icon: Icons.mic_rounded,
                  value: voiceChatVolume,
                  onChanged: (val) => setState(() => voiceChatVolume = val),
                ),
                const Divider(color: Colors.white10, height: 24),
                _buildVolumeSlider(
                  label: 'Music',
                  icon: Icons.music_note_rounded,
                  value: musicVolume,
                  onChanged: (val) => setState(() => musicVolume = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Toggles Section (Vibration & Haptic)
          SettingsSection(
            children: [
              SettingsSwitchTile(
                icon: Icons.vibration_rounded,
                title: 'Enable Vibration',
                subtitle: 'Vibrate during games and alerts',
                value: enableVibration,
                onChanged: (val) => setState(() => enableVibration = val),
              ),
              SettingsSwitchTile(
                icon: Icons.touch_app_outlined,
                title: 'Haptic Feedback',
                subtitle: 'Tactile responses on button taps and triggers',
                value: hapticFeedback,
                onChanged: (val) => setState(() => hapticFeedback = val),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildVolumeSlider({
    required String label,
    required IconData icon,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: accentRed, size: 18),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              '${(value * 100).round()}%',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            activeTrackColor: accentRed,
            inactiveTrackColor: Colors.white10,
            thumbColor: Colors.white,
            overlayColor: primaryRed.withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}