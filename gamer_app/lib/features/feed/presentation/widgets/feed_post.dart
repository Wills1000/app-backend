import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'achievement_card.dart';
import 'comments_sheet.dart';
import 'feed_video.dart';
import 'reaction_bar.dart';
import 'package:gamer_app/features/profile/presentation/pages/user_profile_screen.dart';
import 'package:gamer_app/features/feed/presentation/pages/post_view_screen.dart';

class FeedPostData {
  final String postId;
  final String authorName;
  final String authorAvatar;
  final String timeAgo;
  final String gameTag;
  final String content;
  final String? mediaUrl;
  final String? videoUrl;
  final bool isVideo;
  final String? videoDuration;
  final int likes;
  final int comments;
  final int shares;
  final bool hasAchievement;
  final String? winnerName;
  final String? loserName;
  final String? reward;

  const FeedPostData({
    this.postId = '1',
    required this.authorName,
    required this.authorAvatar,
    required this.timeAgo,
    required this.gameTag,
    required this.content,
    this.mediaUrl,
    this.videoUrl,
    this.isVideo = false,
    this.videoDuration,
    required this.likes,
    required this.comments,
    required this.shares,
    this.hasAchievement = false,
    this.winnerName,
    this.loserName,
    this.reward,
  });
}

class FeedPost extends StatefulWidget {
  final FeedPostData post;

  const FeedPost({
    super.key,
    required this.post,
  });

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  bool isBookmarked = false;

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CommentsSheet(),
    );
  }

  void _openVideoViewer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostViewScreen(
          postId: widget.post.postId,
          videoUrl: widget.post.videoUrl ?? '',
          caption: widget.post.content,
          username: widget.post.authorName,
        ),
      ),
    );
  }

  void _showPostOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141416),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(
                  isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  isBookmarked ? 'Unsave Post' : 'Save Post',
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => isBookmarked = !isBookmarked);
                },
              ),
              ListTile(
                leading: const Icon(Icons.link_rounded, color: Colors.white),
                title: const Text('Share / Copy Link', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Share.share('Check out this post by @${widget.post.authorName}: "${widget.post.content}"');
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_off_outlined, color: Colors.white),
                title: Text('Unfollow @${widget.post.authorName}', style: const TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined, color: Colors.redAccent),
                title: const Text('Report Post', style: TextStyle(color: Colors.redAccent)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xff141416),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xff222226)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileScreen(
                          name: widget.post.authorName,
                          username: widget.post.authorName,
                          avatarUrl: widget.post.authorAvatar,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(widget.post.authorAvatar),
                        backgroundColor: const Color(0xff222226),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.post.authorName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified,
                                  color: Color(0xffE50914),
                                  size: 14,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.post.timeAgo,
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  '•',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    widget.post.gameTag,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xff00FF66),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: _showPostOptions,
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.white38,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Post Text Content
          Text(
            widget.post.content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.4,
            ),
          ),

          // Media Content (Image or Video)
          if (widget.post.mediaUrl != null) ...[
            const SizedBox(height: 10),
            if (widget.post.isVideo)
              GestureDetector(
                onTap: _openVideoViewer,
                child: FeedVideo(
                  thumbnail: widget.post.mediaUrl!,
                  duration: widget.post.videoDuration,
                  tag: '#${widget.post.gameTag.replaceAll(' ', '')}',
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  widget.post.mediaUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: const Color(0xff222226),
                    child: const Icon(Icons.broken_image, color: Colors.white38),
                  ),
                ),
              ),
          ],

          // Optional Achievement Card
          if (widget.post.hasAchievement &&
              widget.post.winnerName != null &&
              widget.post.loserName != null &&
              widget.post.reward != null)
            AchievementCard(
              winnerName: widget.post.winnerName!,
              loserName: widget.post.loserName!,
              reward: widget.post.reward!,
              timeAgo: widget.post.timeAgo,
            ),

          const SizedBox(height: 12),

          // Action Reaction Bar
          ReactionBar(
            initialLikes: widget.post.likes,
            commentsCount: widget.post.comments,
            sharesCount: widget.post.shares,
            onCommentTap: () => _showComments(context),
          ),
        ],
      ),
    );
  }
}