import 'package:flutter/material.dart';

class MediaPickerPreview extends StatelessWidget {
  final VoidCallback onAddMedia;
  final VoidCallback onRemoveMedia;
  final bool hasMedia;

  const MediaPickerPreview({
    super.key,
    required this.onAddMedia,
    required this.onRemoveMedia,
    this.hasMedia = false,
  });

  @override
  Widget build(BuildContext context) {
    if (hasMedia) {
      return Stack(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/600/400'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onRemoveMedia,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onAddMedia,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF141416),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined, color: Colors.white54, size: 32),
            SizedBox(height: 8),
            Text(
              'Add Gameplay Clip or Image',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}