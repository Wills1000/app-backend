import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  final String userName;
  const CallScreen({super.key, required this.userName});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _isMuted = false;
  bool _isSpeakerOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0D0E12),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // User Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xff18191E),
              child: Text(
                widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : 'U',
                style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.userName,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Calling...',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
            const Spacer(),

            // Call Controls
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Mute Button
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: _isMuted ? Colors.white : const Color(0xff18191E),
                    child: IconButton(
                      icon: Icon(
                        _isMuted ? Icons.mic_off : Icons.mic,
                        color: _isMuted ? Colors.black : Colors.white,
                      ),
                      onPressed: () => setState(() => _isMuted = !_isMuted),
                    ),
                  ),

                  // End Call Button
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: const Color(0xffE50914),
                    child: IconButton(
                      icon: const Icon(Icons.call_end, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // Speaker Button
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: _isSpeakerOn ? Colors.white : const Color(0xff18191E),
                    child: IconButton(
                      icon: Icon(
                        _isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                        color: _isSpeakerOn ? Colors.black : Colors.white,
                      ),
                      onPressed: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}