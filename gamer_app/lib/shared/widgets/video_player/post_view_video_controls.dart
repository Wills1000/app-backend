import 'package:flutter/material.dart';

class PostViewVideoControls extends StatelessWidget {
  final bool isPlaying;
  final double progressValue;
  final VoidCallback onPlayPauseTap;
  final ValueChanged<double> onSliderChanged;

  const PostViewVideoControls({
    super.key,
    required this.isPlaying,
    required this.progressValue,
    required this.onPlayPauseTap,
    required this.onSliderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPlayPauseTap,
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          const Text('00:08', style: TextStyle(color: Colors.white, fontSize: 11)),
          Expanded(
            child: SliderTheme(
              data: const SliderThemeData(
                trackHeight: 2,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
                activeTrackColor: Color(0xFFE50914),
                inactiveTrackColor: Colors.white24,
                thumbColor: Colors.white,
              ),
              child: Slider(
                value: progressValue,
                onChanged: onSliderChanged,
              ),
            ),
          ),
          const Text('00:24', style: TextStyle(color: Colors.white, fontSize: 11)),
          const SizedBox(width: 8),
          const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 20),
        ],
      ),
    );
  }
}