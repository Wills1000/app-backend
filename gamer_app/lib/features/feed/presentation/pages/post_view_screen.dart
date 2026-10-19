import 'package:flutter/material.dart';
import '../widgets/comments_sheet.dart';
import 'package:gamer_app/features/profile/presentation/pages/user_profile_screen.dart';
import '../../../../shared/widgets/video_player/post_view_header.dart';
import '../../../../shared/widgets/video_player/post_view_side_actions.dart';
import '../../../../shared/widgets/video_player/post_view_details.dart';
import '../../../../shared/widgets/video_player/post_view_video_controls.dart';
import '../../../../shared/widgets/video_player/post_view_comment_input.dart';
        
class PostViewScreen extends StatefulWidget {
  final String postId;
  final String videoUrl;
  final String caption;
  final String username;
  final String avatarUrl;
  final String timeAgo;
  final String gameTitle;
  final String gameMode;
  final String hashtags;
  final int initialLikes;
  final int initialComments;
  final int initialShares;
  final int initialBookmarks;

  const PostViewScreen({
    super.key,
    required this.postId,
    required this.videoUrl,
    required this.caption,
    required this.username,
    this.avatarUrl = '',
    this.timeAgo = '2h ago',
    this.gameTitle = 'Call of Duty: Mobile',
    this.gameMode = 'Search & Destroy',
    this.hashtags = '#CODMobile #Clutch #SND',
    this.initialLikes = 1500,
    this.initialComments = 134,
    this.initialShares = 48,
    this.initialBookmarks = 92,
  });

  @override
  State<PostViewScreen> createState() => _PostViewScreenState();
}

class _PostViewScreenState extends State<PostViewScreen> {
  bool isPlaying = true;
  double progressValue = 0.33;

  late bool isLiked;
  late int likesCount;
  late bool isBookmarked;
  late int bookmarksCount;
  late int commentsCount;
  late int sharesCount;

  @override
  void initState() {
    super.initState();
    isLiked = false;
    isBookmarked = false;
    likesCount = widget.initialLikes;
    bookmarksCount = widget.initialBookmarks;
    commentsCount = widget.initialComments;
    sharesCount = widget.initialShares;
  }

  void _openUserProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(
          name: widget.username,
          username: widget.username,
          avatarUrl: widget.avatarUrl,
        ),
      ),
    );
  }

  void _openComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CommentsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Video / Thumbnail
          GestureDetector(
            onTap: () => setState(() => isPlaying = !isPlaying),
            child: Positioned.fill(
              child: widget.videoUrl.isNotEmpty
                  ? Image.network(
                      widget.videoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF141416)),
                    )
                  : Container(color: const Color(0xFF141416)),
            ),
          ),

          // Play Overlay Indicator
          if (!isPlaying)
            Center(
              child: GestureDetector(
                onTap: () => setState(() => isPlaying = true),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 48),
                ),
              ),
            ),

          // Gradient Overlay
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black54, Colors.transparent, Colors.transparent, Colors.black87],
                    stops: [0.0, 0.2, 0.6, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),

          // UI Layer
          SafeArea(
            child: Column(
              children: [
                PostViewHeader(
                  username: widget.username,
                  avatarUrl: widget.avatarUrl,
                  timeAgo: widget.timeAgo,
                  onProfileTap: _openUserProfile,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: PostViewDetails(
                          gameTitle: widget.gameTitle,
                          gameMode: widget.gameMode,
                          caption: widget.caption,
                          hashtags: widget.hashtags,
                        ),
                      ),
                      const SizedBox(width: 12),
                      PostViewSideActions(
                        isLiked: isLiked,
                        likesCount: likesCount,
                        commentsCount: commentsCount,
                        sharesCount: sharesCount,
                        isBookmarked: isBookmarked,
                        bookmarksCount: bookmarksCount,
                        onLikeTap: () => setState(() {
                          isLiked = !isLiked;
                          likesCount += isLiked ? 1 : -1;
                        }),
                        onCommentTap: _openComments,
                        onShareTap: () => setState(() => sharesCount++),
                        onBookmarkTap: () => setState(() {
                          isBookmarked = !isBookmarked;
                          bookmarksCount += isBookmarked ? 1 : -1;
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PostViewVideoControls(
                  isPlaying: isPlaying,
                  progressValue: progressValue,
                  onPlayPauseTap: () => setState(() => isPlaying = !isPlaying),
                  onSliderChanged: (val) => setState(() => progressValue = val),
                ),
                const SizedBox(height: 12),
                PostViewCommentInput(
                  onCommentSubmitted: () => setState(() => commentsCount++),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}