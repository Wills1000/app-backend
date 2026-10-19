import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String text)? onSendText;
  final Function(File audioFile)? onSendVoice;
  final Function(File attachmentFile)? onSendAttachment;

  final String? replyMessage;
  final String? replyUser;
  final VoidCallback? onCancelReply;

  const ChatInput({
    super.key,
    this.controller,
    this.onSendText,
    this.onSendVoice,
    this.onSendAttachment,
    this.replyMessage,
    this.replyUser,
    this.onCancelReply,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> with TickerProviderStateMixin {
  late final TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isInternalController = false;
  bool _isTyping = false;
  bool _showEmojiPicker = false;

  // --- Voice Recording State ---
  bool _isRecording = false;
  bool _isPaused = false;
  bool _isLocked = false;
  bool _isPlayingPreview = false;
  bool _hasMicPermission = false;

  String? _tempDirPath;
  String? _recordedFilePath;
  int _recordSeconds = 0;
  Timer? _timer;

  // --- Gesture & Animations ---
  double _dragDx = 0.0;
  double _dragDy = 0.0;
  Offset _startPosition = Offset.zero;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _waveformController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _textController = widget.controller!;
    } else {
      _textController = TextEditingController();
      _isInternalController = true;
    }

    _textController.addListener(_onTextChanged);
    _isTyping = _textController.text.trim().isNotEmpty;

    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _showEmojiPicker) {
        setState(() => _showEmojiPicker = false);
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isPlayingPreview = false);
        _waveformController.stop();
      }
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _waveformController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _warmupRecorder();
  }

  Future<void> _warmupRecorder() async {
    final tempDir = await getTemporaryDirectory();
    _tempDirPath = tempDir.path;
    _hasMicPermission = await Permission.microphone.isGranted;
  }

  void _onTextChanged() {
    final hasText = _textController.text.trim().isNotEmpty;
    if (hasText != _isTyping) {
      setState(() => _isTyping = hasText);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _waveformController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _focusNode.dispose();
    _textController.removeListener(_onTextChanged);
    if (_isInternalController) {
      _textController.dispose();
    }
    super.dispose();
  }

  // --- RECORDING ENGINE ---

  Future<void> _startRecordingInstant() async {
    setState(() {
      _isRecording = true;
      _isPaused = false;
      _isLocked = false;
      _isPlayingPreview = false;
      _recordSeconds = 0;
      _dragDx = 0.0;
      _dragDy = 0.0;
    });

    _waveformController.repeat(reverse: true);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isRecording && !_isPaused) {
        setState(() => _recordSeconds++);
      }
    });

    if (!_hasMicPermission) {
      final status = await Permission.microphone.request();
      _hasMicPermission = status.isGranted;
      if (!_hasMicPermission) {
        _cancelRecording();
        return;
      }
    }

    _tempDirPath ??= (await getTemporaryDirectory()).path;
    _recordedFilePath =
        '$_tempDirPath/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _audioRecorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: _recordedFilePath!,
    );
  }

  Future<void> _handlePauseListenTap() async {
    if (!_isLocked) return;

    if (!_isPaused && !_isPlayingPreview) {
      final path = await _audioRecorder.stop();
      _waveformController.stop();
      setState(() {
        _isPaused = true;
        _recordedFilePath = path;
      });
    } else if (_isPlayingPreview) {
      await _audioPlayer.pause();
      _waveformController.stop();
      setState(() => _isPlayingPreview = false);
    } else if (_isPaused && _recordedFilePath != null) {
      await _audioPlayer.play(DeviceFileSource(_recordedFilePath!));
      _waveformController.repeat(reverse: true);
      setState(() => _isPlayingPreview = true);
    }
  }

  Future<void> _stopAndSendVoice() async {
    if (!_isRecording && _recordedFilePath == null) return;
    _timer?.cancel();

    String? path = _recordedFilePath;
    if (_isRecording && !_isPaused) {
      path = await _audioRecorder.stop();
    }

    await _audioPlayer.stop();

    setState(() {
      _isRecording = false;
      _isLocked = false;
      _isPaused = false;
      _isPlayingPreview = false;
    });

    if (path != null && _recordSeconds >= 1 && widget.onSendVoice != null) {
      widget.onSendVoice!(File(path));
    }
  }

  void _cancelRecording() async {
    _timer?.cancel();
    _waveformController.stop();
    if (_isRecording && !_isPaused) {
      await _audioRecorder.stop();
    }
    await _audioPlayer.stop();
    setState(() {
      _isRecording = false;
      _isPaused = false;
      _isLocked = false;
      _isPlayingPreview = false;
      _recordedFilePath = null;
      _dragDx = 0.0;
      _dragDy = 0.0;
    });
  }

  String _formatTimer(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }
 
  // --- ATTACHMENT & EMOJI ---

  void _toggleEmojiPicker() {
    if (_showEmojiPicker) {
      _showEmojiPicker = false;
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
      _showEmojiPicker = true;
    }
    setState(() {});
  }

  Future<void> _handleAttachment() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff18181C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildAttachmentOption(
              icon: Icons.photo_library_rounded,
              label: 'Gallery',
              color: Colors.purpleAccent,
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            _buildAttachmentOption(
              icon: Icons.camera_alt_rounded,
              label: 'Camera',
              color: const Color(0xffE50914),
              onTap: () => _pickImage(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    final XFile? image = await _imagePicker.pickImage(source: source);
    if (image != null && widget.onSendAttachment != null) {
      widget.onSendAttachment!(File(image.path));
    }
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  void _handleSendText() {
    if (_textController.text.trim().isEmpty) return;
    if (widget.onSendText != null) {
      widget.onSendText!(_textController.text.trim());
    }
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 4),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomRight,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xff18181C),
                          borderRadius: BorderRadius.circular(35),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // --- REPLY PREVIEW BANNER ---
                            if (widget.replyMessage != null)
                              Container(
                                margin: const EdgeInsets.only(top: 4, bottom: 4),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: const Border(
                                    left: BorderSide(
                                        color: Color(0xff8B5CF6), width: 3.5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.replyUser ?? 'Replying',
                                            style: const TextStyle(
                                              color: Color(0xff8B5CF6),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                             Text(
                                            widget.replyMessage!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: widget.onCancelReply,
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(Icons.close_rounded,
                                            color: Colors.white54, size: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // --- INPUT CONTROL BAR (FLEXIBLE HEIGHT) ---
                            ConstrainedBox(
                              constraints: const BoxConstraints(minHeight: 42, maxHeight: 42),
                              child: _isRecording
                                  ? Row(
                                      children: [
                                        // PAUSE / LISTEN BUTTON
                                        if (_isLocked)
                                          GestureDetector(
                                            onTap: _handlePauseListenTap,
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: const BoxDecoration(
                                                color: Color(0xffE50914),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                _isPlayingPreview
                                                    ? Icons.pause_rounded
                                                    : (_isPaused
                                                        ? Icons.play_arrow_rounded
                                                        : Icons.pause_rounded),
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          )
                                        else
                                          ScaleTransition(
                                            scale: _pulseAnimation,
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: const BoxDecoration(
                                                color: Color(0xffE50914),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),

                                        const SizedBox(width: 8),

                                        // TIMER
                                        Text(
                                          _formatTimer(_recordSeconds),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        const SizedBox(width: 8),

                                        // WAVEFORM
                                        Expanded(
                                          child: _isLocked
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 4.0),
                                                  child: AudioWaveformWidget(
                                                    controller:
                                                        _waveformController,
                                                    isAnimating: !_isPaused ||
                                                        _isPlayingPreview,
                                                  ),
                                                )
                                              : Transform.translate(
                                                  offset: Offset(
                                                      _dragDx.clamp(-100.0, 0.0),
                                                      0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: const [
                                                      Icon(
                                                          Icons
                                                              .arrow_back_ios_new_rounded,
                                                          color: Colors.white38,
                                                          size: 12),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        'Slide to cancel',
                                                        style: TextStyle(
                                                            color: Colors.white38,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ),

                                        if (_isLocked)
                                          IconButton(
                                            icon: const Icon(
                                                Icons.delete_outline_rounded,
                                                color: Colors.white54,
                                                size: 20),
                                            onPressed: _cancelRecording,
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                      ],
                                    )
                                  : Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: IconButton(
                                            onPressed: _toggleEmojiPicker,
                                            icon: Icon(
                                              _showEmojiPicker
                                                  ? Icons.keyboard_rounded
                                                  : Icons
                                                      .sentiment_satisfied_alt_rounded,
                                              color: Colors.white70,
                                              size: 22,
                                            ),
                                            splashRadius: 18,
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.all(6),
                                          ),
                                        ),
                                        const SizedBox(width: 4),

                                        // --- MULTI-LINE EXPANDING TEXT FIELD ---
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: TextField(
                                              controller: _textController,
                                              focusNode: _focusNode,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              textInputAction:
                                                  TextInputAction.newline,
                                              minLines: 1,
                                              maxLines: 5,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                              cursorColor:
                                                  const Color(0xffE50914),
                                              decoration: const InputDecoration(
                                                hintText: 'Message',
                                                hintStyle: TextStyle(
                                                    color: Colors.white38,
                                                    fontSize: 14,),
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 6),
                                              ),
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: IconButton(
                                            onPressed: _handleAttachment,
                                            icon: Transform.rotate(
                                              angle: -0.7,
                                              child: const Icon(
                                                  Icons.attach_file_rounded,
                                                  color: Colors.white70,
                                                  size: 20),
                                            ),
                                            splashRadius: 18,
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.all(6),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // ACTION BUTTON (SEND / MIC)
                    if (_isTyping && !_isRecording)
                      GestureDetector(
                        onTap: _handleSendText,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Color(0xffE50914),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.send_rounded,
                              color: Colors.white, size: 22),
                        ),
                      )
                    else
                      Listener(
                        onPointerDown: (event) {
                          if (_isLocked) {
                            _stopAndSendVoice();
                          } else if (!_isRecording) {
                            _startPosition = event.position;
                            _startRecordingInstant();
                          }
                        },
                        onPointerMove: (event) {
                          if (_isRecording && !_isLocked) {
                            final dx = event.position.dx - _startPosition.dx;
                            final dy = event.position.dy - _startPosition.dy;

                            setState(() {
                              _dragDx = dx;
                              _dragDy = dy;
                            });

                            if (dy < -25) {
                              setState(() {
                                _isLocked = true;
                                _dragDx = 0.0;
                                _dragDy = 0.0;
                              });
                            } else if (dx < -70) {
                              _cancelRecording();
                            }
                          }
                        },
                        onPointerUp: (_) {
                          if (_isRecording && !_isLocked) {
                            _stopAndSendVoice();
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: _isRecording ? 54 : 50,
                          height: _isRecording ? 54 : 50,
                          decoration: BoxDecoration(
                            color: const Color(0xffE50914),
                            shape: BoxShape.circle,
                            boxShadow: _isRecording
                                ? [
                                    BoxShadow(
                                      color: const Color(0xffE50914)
                                          .withOpacity(0.4),
                                      blurRadius: 12,
                                      spreadRadius: 3,
                                    )
                                  ]
                                : [],
                          ),
                          child: Icon(
                            _isLocked ? Icons.send_rounded : Icons.mic_rounded,
                            color: Colors.white,
                            size: _isRecording ? 24 : 22,
                          ),
                        ),
                      ),
                  ],
                ),

                // LOCK BADGE OVERLAY
                if (_isRecording && !_isLocked)
                  Positioned(
                    right: 4,
                    bottom: 60,
                    child: Transform.translate(
                      offset: Offset(0, _dragDy.clamp(-60.0, 0.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff18181C),
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.lock_outline_rounded,
                                color: Colors.white70, size: 16),
                            SizedBox(height: 2),
                            Icon(Icons.keyboard_arrow_up_rounded,
                                color: Colors.white38, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // EMOJI PICKER
          if (_showEmojiPicker)
            SizedBox(
              height: 250,
              child: EmojiPicker(
                textEditingController: _textController,
                config: const Config(
                  height: 250,
                  checkPlatformCompatibility: true,
                  emojiViewConfig: EmojiViewConfig(
                    columns: 7,
                    backgroundColor: Color(0xff141416),
                  ),
                  categoryViewConfig: CategoryViewConfig(
                    backgroundColor: Color(0xff141416),
                    indicatorColor: Color(0xffE50914),
                    iconColorSelected: Color(0xffE50914),
                    iconColor: Colors.white38,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// --- DYNAMIC AUDIO WAVEFORM COMPONENT ---
class AudioWaveformWidget extends StatelessWidget {
  final AnimationController controller;
  final bool isAnimating;

  const AudioWaveformWidget({
    super.key,
    required this.controller,
    required this.isAnimating,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(15, (index) {
              double baseHeight = math.sin((index / 15) * math.pi) * 18;
              double animFactor = isAnimating
                  ? math.sin((controller.value * 2 * math.pi) + (index * 0.4))
                      .abs()
                  : 0.25;

              double barHeight = (baseHeight * animFactor).clamp(4.0, 20.0);

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 1.2),
                width: 3,
                height: barHeight,
                decoration: BoxDecoration(
                  color: const Color(0xffE50914).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}