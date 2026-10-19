import 'package:flutter/material.dart';

class PostViewSideActions extends StatelessWidget {
  final bool isLiked;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isBookmarked;
  final int bookmarksCount;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final VoidCallback onBookmarkTap;

  const PostViewSideActions({
    super.key,
    required this.isLiked,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.isBookmarked,
    required this.bookmarksCount,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onShareTap,
    required this.onBookmarkTap,
  });

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildItem(Icons.favorite, isLiked ? Colors.red : Colors.white, _formatCount(likesCount), onLikeTap),
        const SizedBox(height: 16),
        _buildItem(Icons.chat_bubble_rounded, Colors.white, _formatCount(commentsCount), onCommentTap),
        const SizedBox(height: 16),
        _buildItem(Icons.shortcut_rounded, Colors.white, _formatCount(sharesCount), onShareTap),
        const SizedBox(height: 16),
        _buildItem(Icons.bookmark_rounded, isBookmarked ? const Color(0xFFFFD700) : Colors.white, _formatCount(bookmarksCount), onBookmarkTap),
      ],
    );
  }

  Widget _buildItem(IconData icon, Color iconColor, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}