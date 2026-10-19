import 'package:flutter/material.dart';
import 'package:gamer_app/core/widgets/app_background.dart';
import '../widgets/media_picker_preview.dart';

class CreatePostScreen extends StatefulWidget {
  static const String routeName = '/create-post';

  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  static const Color primaryRed = Color(0xFF970303);
  final TextEditingController _textController = TextEditingController();
  
  bool _hasMedia = false;
  String _selectedGame = 'PUBG Mobile';

  final List<String> _games = [
    'PUBG Mobile',
    'Call of Duty Mobile',
    'eFootball 2026',
    'Free Fire',
    'General',
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090304),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Create Post',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0, top: 10.0, bottom: 10.0),
            child: ElevatedButton(
              onPressed: () {
                // Submit post logic to feed provider
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Post',
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryRed, width: 1.5),
                              image: const DecorationImage(
                                image: NetworkImage('https://picsum.photos/200/200'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Princewill',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1B1B1E),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedGame,
                                    dropdownColor: const Color(0xFF1B1B1E),
                                    isDense: true,
                                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white54, size: 16),
                                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() => _selectedGame = newValue);
                                      }
                                    },
                                    items: _games.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _textController,
                        maxLines: 6,
                        minLines: 3,
                        style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
                        decoration: const InputDecoration(
                          hintText: "What's on your mind? Share highlights, challenge someone, or brag...",
                          hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 16),
                      MediaPickerPreview(
                        hasMedia: _hasMedia,
                        onAddMedia: () => setState(() => _hasMedia = true),
                        onRemoveMedia: () => setState(() => _hasMedia = false),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF141416),
                  border: Border(top: BorderSide(color: Colors.white10)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image_outlined, color: Colors.white70, size: 22),
                      onPressed: () => setState(() => _hasMedia = true),
                    ),
                    IconButton(
                      icon: const Icon(Icons.videocam_outlined, color: Colors.white70, size: 22),
                      onPressed: () => setState(() => _hasMedia = true),
                    ),
                    IconButton(
                      icon: const Icon(Icons.emoji_events_outlined, color: Colors.white70, size: 22),
                      onPressed: () {
                        // Attach match result or trophy
                      },
                    ),
                    const Spacer(),
                    const Text(
                      'Public',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.public_rounded, color: Colors.white54, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}