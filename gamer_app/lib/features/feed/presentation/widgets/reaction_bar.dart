import 'package:flutter/material.dart';

class ReactionBar extends StatefulWidget {
  final int initialLikes;
  final int commentsCount;
  final int sharesCount;
  final VoidCallback? onCommentTap;

  const ReactionBar({
    super.key,
    required this.initialLikes,
    required this.commentsCount,
    required this.sharesCount,
    this.onCommentTap,
  });

  @override
  State<ReactionBar> createState() => _ReactionBarState();
}

class _ReactionBarState extends State<ReactionBar> {
  bool isLiked = false;
  bool isBookmarked = false;
  late int likesCount;

  @override
  void initState() {
    super.initState();
    likesCount = widget.initialLikes;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Like Button
        GestureDetector(
          onTap: () {
            setState(() {
              isLiked = !isLiked;
              likesCount += isLiked ? 1 : -1;
            });
          },
          child: Row(
            children: [
              Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? const Color(0xffE50914) : Colors.white54,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                '$likesCount',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),

        // Comment Button
        GestureDetector(
          onTap: widget.onCommentTap,
          child: Row(
            children: [
              const Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 18),
              const SizedBox(width: 6),
              Text(
                '${widget.commentsCount}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),

        // Share Button
        Row(
          children: [
            const Icon(Icons.send_outlined, color: Colors.white54, size: 18),
            const SizedBox(width: 6),
            Text(
              '${widget.sharesCount}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),

        const Spacer(),

        // Bookmark Button
        GestureDetector(
          onTap: () => setState(() => isBookmarked = !isBookmarked),
          child: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: isBookmarked ? Colors.white : Colors.white54,
            size: 20,
          ),
        ),
      ],
    );
  }
}