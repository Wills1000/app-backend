import 'package:flutter/material.dart';
import 'package:gamer_app/features/feed/presentation/pages/create_post_screen.dart';

class PostInput extends StatelessWidget {
  const PostInput({super.key});

  void _navigateToCreatePost(BuildContext context) {
    Navigator.pushNamed(context, CreatePostScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _navigateToCreatePost(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xff141416),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xff222226)),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage('https://placeholder.co/100'),
                    backgroundColor: Color(0xff222226),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: const BoxDecoration(
                        color: Color(0xffE50914),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "What's on your mind?",
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ),
              // IgnorePointer lets tap events pass straight through to GestureDetector
              const IgnorePointer(
                child: Icon(
                  Icons.image_outlined,
                  color: Colors.white54,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}