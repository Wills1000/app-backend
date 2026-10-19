import 'package:flutter/material.dart';

class StatusReplyBar extends StatefulWidget {
  final FocusNode focusNode;
  final Function(String text) onSendReply;
  final Function(String emoji) onSendReaction;

  const StatusReplyBar({
    super.key,
    required this.focusNode,
    required this.onSendReply,
    required this.onSendReaction,
  });

  @override
  State<StatusReplyBar> createState() => _StatusReplyBarState();
}

class _StatusReplyBarState extends State<StatusReplyBar> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _quickReactions = ['🔥', '❤️', '😂', '👏', '😮', '💯'];

  void _submitReply() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendReply(text);
      _controller.clear();
      widget.focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      color: Colors.black45,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quick Reaction Row
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _quickReactions.length,
              itemBuilder: (context, index) {
                final emoji = _quickReactions[index];
                return GestureDetector(
                  onTap: () => widget.onSendReaction(emoji),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 18)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // DM Input Bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: widget.focusNode,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Reply to status...',
                    hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                    filled: true,
                    fillColor: const Color(0xff1C1C22),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: Color(0xff2A2A32)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: Color(0xffE50914)),
                    ),
                  ),
                  onSubmitted: (_) => _submitReply(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _submitReply,
                icon: const Icon(Icons.send_rounded, color: Color(0xffE50914)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}