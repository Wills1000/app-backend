import 'package:flutter/material.dart';

class PostViewCommentInput extends StatefulWidget {
  final VoidCallback onCommentSubmitted;

  const PostViewCommentInput({
    super.key,
    required this.onCommentSubmitted,
  });

  @override
  State<PostViewCommentInput> createState() => _PostViewCommentInputState();
}

class _PostViewCommentInputState extends State<PostViewCommentInput> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onCommentSubmitted();
      _controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(22),
              ),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                onSubmitted: (_) => _submit(),
                decoration: const InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _submit,
            child: Container(
              height: 44,
              width: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFE50914),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}