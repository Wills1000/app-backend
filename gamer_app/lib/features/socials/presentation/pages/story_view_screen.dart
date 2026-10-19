import 'package:flutter/material.dart';

class UserStatusModel {
  final String userId;
  final String userName;
  final String avatarUrl;
  final List<String> statusImages;
  final bool isOnline;
  int viewedCount;

  UserStatusModel({
    required this.userId,
    required this.userName,
    required this.avatarUrl,
    required this.statusImages,
    this.isOnline = true,
    this.viewedCount = 0,
  });
}

class StoryViewScreen extends StatefulWidget {
  final List<UserStatusModel> allStatuses;
  final int initialUserIndex;
  final Function(String userId, int viewedCount)? onViewedUpdated;

  const StoryViewScreen({
    super.key,
    required this.allStatuses,
    required this.initialUserIndex,
    this.onViewedUpdated,
  });

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  late int _currentUserIndex;
  int _currentImageIndex = 0;
  final TextEditingController _replyController = TextEditingController();
  bool _isTyping = false;

  final List<Map<String, String>> _dummyViewers = [
    {'name': 'KingTobi', 'time': '2m ago', 'avatar': 'https://picsum.photos/100'},
    {'name': 'Ghostzy', 'time': '15m ago', 'avatar': 'https://picsum.photos/100'},
    {'name': 'QueenB', 'time': '1h ago', 'avatar': 'https://picsum.photos/100'},
  ];

  @override
  void initState() {
    super.initState();
    _currentUserIndex = widget.initialUserIndex;
    _replyController.addListener(() {
      setState(() {
        _isTyping = _replyController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  UserStatusModel get _currentUser => widget.allStatuses[_currentUserIndex];

  void _nextStatus() {
    if (_currentImageIndex < _currentUser.statusImages.length - 1) {
      setState(() {
        _currentImageIndex++;
      });
    } else {
      _nextUser();
    }
  }

  void _previousStatus() {
    if (_currentImageIndex > 0) {
      setState(() {
        _currentImageIndex--;
      });
    } else {
      _previousUser();
    }
  }

  void _nextUser() {
    if (_currentUserIndex < widget.allStatuses.length - 1) {
      setState(() {
        _currentUserIndex++;
        _currentImageIndex = 0;
      });
    } else {
      Navigator.pop(context); // Close when reaching the very end
    }
  }

  void _previousUser() {
    if (_currentUserIndex > 0) {
      setState(() {
        _currentUserIndex--;
        _currentImageIndex = 0;
      });
    } else {
      setState(() {
        _currentImageIndex = 0;
      });
    }
  }

  void _showViewersSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF18181B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Viewed by ${_dummyViewers.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const Divider(color: Colors.white12),
              Expanded(
                child: ListView.builder(
                  itemCount: _dummyViewers.length,
                  itemBuilder: (context, index) {
                    final viewer = _dummyViewers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(viewer['avatar']!),
                      ),
                      title: Text(
                        viewer['name']!,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      subtitle: Text(
                        viewer['time']!,
                        style: const TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusCount = _currentUser.statusImages.length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: GestureDetector(
          // Swipe down to dismiss, swipe left/right for next/prev player
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
              Navigator.pop(context);
            }
          },
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null) {
              if (details.primaryVelocity! < -300) {
                _nextUser();
              } else if (details.primaryVelocity! > 300) {
                _previousUser();
              }
            }
          },
          child: Column(
            children: [
              // Segmented Status Indicators Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: List.generate(statusCount, (index) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: 3,
                        decoration: BoxDecoration(
                          color: index <= _currentImageIndex
                              ? const Color(0xffE50914)
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Header: Avatar, Username & Close
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey[800],
                      backgroundImage: NetworkImage(_currentUser.avatarUrl),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _currentUser.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 26),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Status Media Display with Tap Controls (Left = Back, Right = Forward)
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          'https://picsum.photos/600/1000?random=$_currentImageIndex',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[900],
                              child: const Center(
                                child: Icon(Icons.broken_image, color: Colors.white38, size: 50),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _previousStatus,
                            child: const SizedBox.expand(),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _nextStatus,
                            child: const SizedBox.expand(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bottom Input & Viewer Bar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye, color: Colors.white70, size: 26),
                      onPressed: _showViewersSheet,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: TextField(
                          controller: _replyController,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Reply to status...',
                            hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        _isTyping ? Icons.send_rounded : Icons.favorite,
                        color: _isTyping ? const Color(0xffE50914) : Colors.redAccent,
                        size: 28,
                      ),
                      onPressed: () {
                        if (_isTyping) {
                          _replyController.clear();
                          FocusScope.of(context).unfocus();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sent ❤️ reaction'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                    ),
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