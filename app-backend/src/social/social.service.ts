// app-backend/src/social/social.service.ts
import { Injectable, NotFoundException, BadRequestException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { FriendRequestStatus } from '@prisma/client';

@Injectable()
export class SocialService {
  constructor(private prisma: PrismaService) {}

  // 1 & 2. Follow / Unfollow Player
  async followUser(followerId: string, followingId: string) {
    if (followerId === followingId) throw new BadRequestException('You cannot follow yourself');
    
    return this.prisma.follow.create({
      data: { followerId, followingId },
    });
  }

  async unfollowUser(followerId: string, followingId: string) {
    try {
      return await this.prisma.follow.delete({
        where: {
          followerId_followingId: { followerId, followingId },
        },
      });
    } catch (error) {
      throw new NotFoundException('Follow relationship not found');
    }
  }

  // 3. Send Friend Request
  async sendFriendRequest(senderId: string, receiverId: string) {
    if (senderId === receiverId) throw new BadRequestException('Cannot send friend request to yourself');

    const existing = await this.prisma.friendRequest.findFirst({
      where: {
        OR: [
          { senderId, receiverId },
          { senderId: receiverId, receiverId: senderId },
        ],
      },
    });

    if (existing) {
      throw new ConflictException('Friend request or friendship already exists between users');
    }

    return this.prisma.friendRequest.create({
      data: { senderId, receiverId, status: FriendRequestStatus.PENDING },
    });
  }

  // 4. Accept Friend Request
  async acceptFriendRequest(userId: string, requestId: string) {
    const request = await this.prisma.friendRequest.findUnique({ where: { id: requestId } });
    if (!request || request.receiverId !== userId) throw new NotFoundException('Friend request not found');
    if (request.status !== FriendRequestStatus.PENDING) throw new BadRequestException('Request is no longer pending');

    return this.prisma.friendRequest.update({
      where: { id: requestId },
      data: { status: FriendRequestStatus.ACCEPTED },
    });
  }

  // 5. Reject Friend Request
  async rejectFriendRequest(userId: string, requestId: string) {
    const request = await this.prisma.friendRequest.findUnique({ where: { id: requestId } });
    if (!request || request.receiverId !== userId) throw new NotFoundException('Friend request not found');

    return this.prisma.friendRequest.update({
      where: { id: requestId },
      data: { status: FriendRequestStatus.DECLINED },
    });
  }

  // 6. Cancel Friend Request
  async cancelFriendRequest(userId: string, requestId: string) {
    const request = await this.prisma.friendRequest.findUnique({ where: { id: requestId } });
    if (!request || request.senderId !== userId) throw new NotFoundException('Friend request not found');

    return this.prisma.friendRequest.delete({ where: { id: requestId } });
  }

  // 7. Remove Friend / Unfriend
  async removeFriend(userId: string, friendId: string) {
    const request = await this.prisma.friendRequest.findFirst({
      where: {
        status: FriendRequestStatus.ACCEPTED,
        OR: [
          { senderId: userId, receiverId: friendId },
          { senderId: friendId, receiverId: userId },
        ],
      },
    });

    if (!request) throw new NotFoundException('Friendship not found');
    return this.prisma.friendRequest.delete({ where: { id: request.id } });
  }

  // 8. Get Friends List
  async getFriends(userId: string) {
    const requests = await this.prisma.friendRequest.findMany({
      where: {
        status: FriendRequestStatus.ACCEPTED,
        OR: [{ senderId: userId }, { receiverId: userId }],
      },
      include: {
        sender: { select: { id: true, username: true, avatarUrl: true, lastActiveAt: true } },
        receiver: { select: { id: true, username: true, avatarUrl: true, lastActiveAt: true } },
      },
    });

    return requests.map(req => (req.senderId === userId ? req.receiver : req.sender));
  }

  // 9. Get Followers
  async getFollowers(userId: string) {
    const follows = await this.prisma.follow.findMany({
      where: { followingId: userId },
      include: { follower: { select: { id: true, username: true, avatarUrl: true, lastActiveAt: true } } },
    });
    return follows.map(f => f.follower);
  }

  // 10. Get Following
  async getFollowing(userId: string) {
    const follows = await this.prisma.follow.findMany({
      where: { followerId: userId },
      include: { following: { select: { id: true, username: true, avatarUrl: true, lastActiveAt: true } } },
    });
    return follows.map(f => f.following);
  }

  // 11 & 12. Block / Unblock Player
  async blockPlayer(blockerId: string, blockedId: string) {
    if (blockerId === blockedId) throw new BadRequestException('Cannot block yourself');
    return this.prisma.block.create({ data: { blockerId, blockedId } });
  }

  async unblockPlayer(blockerId: string, blockedId: string) {
    try {
      return await this.prisma.block.delete({
        where: {
          blockerId_blockedId: { blockerId, blockedId },
        },
      });
    } catch (error) {
      throw new NotFoundException('Block record not found');
    }
  }

  // 13 & 14. Online Presence & Last Seen update
  async updateLastActive(userId: string) {
    return this.prisma.user.update({
      where: { id: userId },
      data: { lastActiveAt: new Date() },
    });
  }

  // 15. Online Player List (Active within last 5 minutes)
  async getOnlinePlayers() {
    const fiveMinutesAgo = new Date(Date.now() - 5 * 60 * 1000);
    return this.prisma.user.findMany({
      where: { lastActiveAt: { gte: fiveMinutesAgo } },
      select: { id: true, username: true, avatarUrl: true, lastActiveAt: true },
    });
  }
}