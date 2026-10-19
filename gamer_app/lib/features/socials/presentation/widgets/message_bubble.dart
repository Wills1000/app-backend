import 'package:flutter/material.dart';

class MessageBubble extends StatefulWidget {
  final String message;
  final String time;
  final bool isMe;
  final bool isRead;
  final String? userAvatar;
  final VoidCallback? onReply;

  const MessageBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isMe,
    this.isRead = false,
    this.userAvatar,
    this.onReply,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  double _dragOffset = 0.0;
  static const double _maxDrag = 60.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (details.delta.dx > 0 || _dragOffset > 0) {
      setState(() {
        _dragOffset = (_dragOffset + details.delta.dx).clamp(0.0, _maxDrag);
      });
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_dragOffset >= _maxDrag * 0.6) {
      if (widget.onReply != null) {
        widget.onReply!();
      }
    }
    setState(() {
      _dragOffset = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Stack(
        children: [
          if (_dragOffset > 0)
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: Opacity(
                  opacity: (_dragOffset / _maxDrag).clamp(0.0, 1.0),
                  child: const Icon(
                    Icons.reply_rounded,
                    color: Color(0xffE50914),
                    size: 22,
                  ),
                ),
              ),
            ),

          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(_dragOffset, 0, 0),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Row(
              mainAxisAlignment:
                  widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!widget.isMe && widget.userAvatar != null) ...[
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(widget.userAvatar!),
                    backgroundColor: const Color(0xff222226),
                  ),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Stack(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.72,
                        ),
                        padding: EdgeInsets.fromLTRB(
                          widget.isMe ? 22 : 14, // Extra padding on left for "isMe" to fit dot inside
                          10,
                          14,
                          10,
                        ),
                        decoration: BoxDecoration(
                          color: widget.isMe
                              ? const Color(0xffE50914)
                              : const Color(0xff141416),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(widget.isMe ? 16 : 0),
                            bottomRight: Radius.circular(widget.isMe ? 0 : 16),
                          ),
                          border: Border.all(
                            color: widget.isMe
                                ? const Color(0xffE50914)
                                : const Color(0xff222226),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: widget.isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.message,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.time,
                              style: TextStyle(
                                color: widget.isMe
                                    ? Colors.white70
                                    : Colors.white38,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.isMe)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.isRead
                                  ? const Color(0xff00FF66)
                                  : Colors.black,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}