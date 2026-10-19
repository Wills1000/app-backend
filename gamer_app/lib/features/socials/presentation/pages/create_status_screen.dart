import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateStatusScreen extends StatefulWidget {
  const CreateStatusScreen({super.key});

  @override
  State<CreateStatusScreen> createState() => _CreateStatusScreenState();
}

class _CreateStatusScreenState extends State<CreateStatusScreen> {
  int _selectedTypeIndex = 0; // 0: Text, 1: Photo, 2: Video, 3: Poll
  int _selectedBgIndex = 0;
  bool _allowRepost = true;
  String _visibility = 'Public';

  File? _selectedImage;
  File? _selectedVideo;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _statusTextController = TextEditingController();
  final TextEditingController _pollQuestionController = TextEditingController();
  final List<TextEditingController> _pollOptionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  final List<Map<String, dynamic>> _typeOptions = [
    {'icon': Icons.edit, 'label': 'Text'},
    {'icon': Icons.image, 'label': 'Photo'},
    {'icon': Icons.videocam, 'label': 'Video'},
    {'icon': Icons.poll, 'label': 'Poll'},
  ];

  final List<Color> _backgroundColors = [
    const Color(0xff1C0A0C),
    const Color(0xff2A1B3D),
    const Color(0xff18222A),
    const Color(0xff3D1B1B),
    const Color(0xff1B2A38),
  ];

  @override
  void dispose() {
    _statusTextController.dispose();
    _pollQuestionController.dispose();
    for (var controller in _pollOptionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _selectedVideo = File(video.path);
      });
    }
  }

  void _showVisibilityBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff18191E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Who can see this?',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.public, color: Colors.white),
                title: const Text('Public', style: TextStyle(color: Colors.white)),
                trailing: _visibility == 'Public' ? const Icon(Icons.check, color: Color(0xffE50914)) : null,
                onTap: () {
                  setState(() => _visibility = 'Public');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.people, color: Colors.white),
                title: const Text('Friends', style: TextStyle(color: Colors.white)),
                trailing: _visibility == 'Friends' ? const Icon(Icons.check, color: Color(0xffE50914)) : null,
                onTap: () {
                  setState(() => _visibility = 'Friends');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.white),
                title: const Text('Only Me', style: TextStyle(color: Colors.white)),
                trailing: _visibility == 'Only Me' ? const Icon(Icons.check, color: Color(0xffE50914)) : null,
                onTap: () {
                  setState(() => _visibility = 'Only Me');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMediaContentArea() {
    switch (_selectedTypeIndex) {
      case 1: // Photo
        return GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xff18191E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: _selectedImage != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          _selectedImage!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            backgroundColor: Colors.black.withOpacity(0.6),
                            radius: 18,
                            child: const Icon(Icons.edit, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_a_photo_outlined, color: Colors.white54, size: 48),
                      SizedBox(height: 12),
                      Text(
                        'Tap to select a photo from gallery',
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
          ),
        );

      case 2: // Video
        return GestureDetector(
          onTap: _pickVideo,
          child: Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xff18191E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: _selectedVideo != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_outline, color: Color(0xffE50914), size: 54),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          _selectedVideo!.path.split('/').last,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap to change video',
                        style: TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.video_call_outlined, color: Colors.white54, size: 48),
                      SizedBox(height: 12),
                      Text(
                        'Tap to select a video to upload',
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
          ),
        );

      case 3: // Poll
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xff18191E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _pollQuestionController,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: 'Ask a question...',
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 16),
                  border: InputBorder.none,
                ),
              ),
              const Divider(color: Colors.white12),
              ...List.generate(_pollOptionControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: _pollOptionControllers[index],
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Option ${index + 1}',
                      hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                );
              }),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _pollOptionControllers.add(TextEditingController());
                  });
                },
                icon: const Icon(Icons.add, color: Color(0xffE50914), size: 18),
                label: const Text(
                  'Add Option',
                  style: TextStyle(color: Color(0xffE50914), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );

      case 0: // Text Mode
      default:
        return Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _backgroundColors[_selectedBgIndex],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Stack(
            children: [
              TextField(
                controller: _statusTextController,
                maxLines: null,
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 22, fontWeight: FontWeight.bold),
                  border: InputBorder.none,
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white10,
                        shape: BoxShape.circle,
                      ),
                      child: const Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white10,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.palette_outlined, color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ),
              const Positioned(
                right: 0,
                bottom: 4,
                child: Text('120', style: TextStyle(color: Colors.white38, fontSize: 12)),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0D0E12),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Status',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Post',
              style: TextStyle(color: Color(0xffE50914), fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media Type Options Row
            Row(
              children: List.generate(_typeOptions.length, (index) {
                final isSelected = _selectedTypeIndex == index;
                final option = _typeOptions[index];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTypeIndex = index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xff18191E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xffE50914) : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            option['icon'],
                            color: isSelected ? const Color(0xffE50914) : Colors.white70,
                            size: 22,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            option['label'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white54,
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Dynamic Content Area
            _buildMediaContentArea(),
            const SizedBox(height: 20),

            // Background Selector (Text Mode Only)
            if (_selectedTypeIndex == 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Choose Background',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All', style: TextStyle(color: Color(0xffE50914), fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _backgroundColors.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedBgIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedBgIndex = index),
                      child: Container(
                        width: 65,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: _backgroundColors[index],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xffE50914) : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Center(
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Color(0xffE50914),
                                  child: Icon(Icons.check, size: 16, color: Colors.white),
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Settings Box
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff18191E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.white10,
                      child: Icon(Icons.language, color: Colors.white, size: 20),
                    ),
                    title: const Text('Who can see this?', style: TextStyle(color: Colors.white, fontSize: 14)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_visibility, style: const TextStyle(color: Color(0xffE50914), fontSize: 14)),
                        const Icon(Icons.chevron_right, color: Colors.white38),
                      ],
                    ),
                    onTap: _showVisibilityBottomSheet,
                  ),
                  const Divider(color: Colors.white12, height: 1),
                  SwitchListTile(
                    secondary: const CircleAvatar(
                      backgroundColor: Colors.white10,
                      child: Icon(Icons.repeat, color: Colors.white, size: 20),
                    ),
                    title: const Text('Allow repost', style: TextStyle(color: Colors.white, fontSize: 14)),
                    activeColor: const Color(0xffE50914),
                    value: _allowRepost,
                    onChanged: (val) => setState(() => _allowRepost = val),
                  ),
                  const Divider(color: Colors.white12, height: 1),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.white10,
                      child: Icon(Icons.location_on_outlined, color: Colors.white, size: 20),
                    ),
                    title: const Text('Add location', style: TextStyle(color: Colors.white, fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.white38),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}