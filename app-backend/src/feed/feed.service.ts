// app-backend/src/feed/feed.service.ts
import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

// Define the privacy type locally as a string union to completely bypass Prisma's client generation issue
export type PostPrivacy = 'PUBLIC' | 'FOLLOWERS_ONLY' | 'PRIVATE';

@Injectable()
export class FeedService {
  constructor(private prisma: PrismaService) {}

  // [1] Create Post
  async createPost(userId: string, data: { content?: string; mediaUrl?: string; mediaType?: string; thumbnailUrl?: string; privacy?: PostPrivacy }) {
    return this.prisma.post.create({
      data: {
        authorId: userId,
        content: data.content,
        privacy: (data.privacy as any) || 'PUBLIC', // Prisma accepts the raw string fine
        media: data.mediaUrl ? {
          create: {
            url: data.mediaUrl,
            type: data.mediaType || 'IMAGE'
          }
        } : undefined
      },
      include: {
        author: { select: { id: true, profile: { select: { username: true, avatarUrl: true } } } },
        media: true,
        likes: true,
        comments: true,
      },
    });
  }

  // [2] Edit Post
  async editPost(userId: string, postId: string, data: { content?: string }) {
    const post = await this.prisma.post.findUnique({ where: { id: postId } });
    if (!post) throw new NotFoundException('Post not found');
    if (post.authorId !== userId) throw new ForbiddenException('You can only edit your own posts');

    return this.prisma.post.update({
      where: { id: postId },
      data: { content: data.content },
      include: {
        author: { select: { id: true, profile: { select: { username: true, avatarUrl: true } } } },
        media: true,
        likes: true,
        comments: true,
      },
    });
  }

  // [3] Delete Post
  async deletePost(userId: string, postId: string) {
    const post = await this.prisma.post.findUnique({ where: { id: postId } });
    if (!post) throw new NotFoundException('Post not found');
    if (post.authorId !== userId) throw new ForbiddenException('You can only delete your own posts');

    return this.prisma.post.delete({ where: { id: postId } });
  }

  // [4] Get Feed (with Pagination)
  async getFeed(userId: string, page = 1, limit = 10) {
    const skip = (page - 1) * limit;
    return this.prisma.post.findMany({
      skip,
      take: limit,
      orderBy: { createdAt: 'desc' },
      include: {
        author: { select: { id: true, profile: { select: { username: true, avatarUrl: true } } } },
        media: true,
        likes: true,
        comments: {
          include: {
            user: { select: { id: true, profile: { select: { username: true, avatarUrl: true } } } }
          }
        },
        shares: true,
      },
    });
  }

  // [10] Unlike Post
  async unlikePost(userId: string, postId: string) {
    const like = await this.prisma.postLike.findUnique({
      where: { postId_userId: { postId, userId } },
    });
    if (!like) throw new NotFoundException('Like not found');

    return this.prisma.postLike.delete({ where: { id: like.id } });
  }

  // [11] Comment on Post
  async addComment(userId: string, postId: string, content: string) {
    return this.prisma.postComment.create({
      data: { userId, postId, content },
      include: {
        user: { select: { id: true, profile: { select: { username: true, avatarUrl: true } } } },
      },
    });
  }

  // [12] Delete Comment
  async deleteComment(userId: string, commentId: string) {
    const comment = await this.prisma.postComment.findUnique({ where: { id: commentId } });
    if (!comment) throw new NotFoundException('Comment not found');
    if (comment.userId !== userId) throw new ForbiddenException('You can only delete your own comments');

    return this.prisma.postComment.delete({ where: { id: commentId } });
  }
}