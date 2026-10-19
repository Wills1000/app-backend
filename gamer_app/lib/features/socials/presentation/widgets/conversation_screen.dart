import 'package:flutter/material.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';
import '../pages/call_screen.dart';

class ConversationScreen extends StatefulWidget {
  final String userName;
  final String userAvatar;
  final String gameTag;

  const ConversationScreen({
    super.key,
    required this.userName,
    required this.userAvatar,
    required this.gameTag,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();

  String? _replyMessage;
  String? _replyUser;

  void _onMessageReply(String message, String user) {
    setState(() {
      _replyMessage = message;
      _replyUser = user;
    });
  }

  void _cancelReply() {
    setState(() {
      _replyMessage = null;
      _replyUser = null;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090304),
      appBar: AppBar(
        backgroundColor: const Color(0xff141416),
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.userAvatar),
              backgroundColor: const Color(0xff222226),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.gameTag,
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.white, size: 23),
            onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CallScreen(userName: widget.userName),
    ),
  );
},
          ), 
          PopupMenuButton<String>(
  icon: const Icon(Icons.more_vert, color: Colors.white),
  onSelected: (value) {
    // Handle actions: 'block', 'favourite', 'theme'
  },
  itemBuilder: (context) => [
    const PopupMenuItem(value: 'block', child: Text('Block')),
    const PopupMenuItem(value: 'favourite', child: Text('Add to Favourite')),
    const PopupMenuItem(value: 'theme', child: Text('Chat Theme')),
  ],
),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                MessageBubble(
                  message: "Hey! Ready for the match tonight?",
                  time: "9:35 PM",
                  isMe: false,
                  userAvatar: widget.userAvatar,
                  onReply: () => _onMessageReply(
                    "Hey! Ready for the match tonight?",
                    widget.userName,
                  ),
                ),
                MessageBubble(
                  message:
                      "Yeah, locked in! Let's run it back later tonight 💪",
                  time: "9:40 PM",
                  isMe: true,
                  userAvatar: widget.userAvatar,
                  onReply: () => _onMessageReply(
                    "Yeah, locked in! Let's run it back later tonight 💪",
                    "You",
                  ),
                ),
              ],
            ),
          ),
          ChatInput(
  controller: _messageController,
  replyMessage: _replyMessage,
  replyUser: _replyUser,
  onCancelReply: _cancelReply,
  onSendText: (text) {
    // 1. Handle sending text message
    setState(() {
      // Add your new text message logic here
    });
    _cancelReply();
  },
  onSendVoice: (audioFile) {
    // 2. Handle sending recorded audio file (.m4a)
    print("Voice recorded at: ${audioFile.path}");
    _cancelReply();
  },
  onSendAttachment: (attachmentFile) {
    // 3. Handle sending gallery/camera image
    print("Attachment picked at: ${attachmentFile.path}");
    _cancelReply();
  },
)
        ],
      ),
    );
  }
}