import { Injectable, ForbiddenException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ModerationService {
  constructor(private prisma: PrismaService) {}

  /**
   * Helper to log administrative and moderation actions
   */
  private async logAction(adminId: string, action: string, reason: string, targetUserId?: string) {
    const db: any = this.prisma;
    return db.moderationLog.create({
      data: { adminId, action, reason, targetUserId },
    });
  }

  /**
   * Suspend or Ban a Player
   */
  async updateUserStatus(adminId: string, targetUserId: string, status: 'SUSPENDED' | 'BANNED' | 'ACTIVE', reason: string) {
    const db: any = this.prisma;
    const user = await db.user.findUnique({ where: { id: targetUserId } });
    if (!user) throw new NotFoundException('Target user not found');

    const updatedUser = await db.user.update({
      where: { id: targetUserId },
      data: { status },
    });

    await this.logAction(adminId, `USER_${status}`, reason, targetUserId);
    return updatedUser;
  }

  /**
   * Remove Post or Content
   */
  async removePost(adminId: string, postId: string, reason: string) {
    const db: any = this.prisma;
    // Assuming a Post model exists in your schema
    const post = await db.post.delete({ where: { id: postId } }).catch(() => null);
    if (!post) throw new NotFoundException('Post not found');

    await this.logAction(adminId, 'REMOVE_POST', reason);
    return { message: 'Post successfully removed', postId };
  }

  /**
   * Moderate Message or Chat
   */
  async removeMessage(adminId: string, messageId: string, reason: string) {
    const db: any = this.prisma;
    const message = await db.message.delete({ where: { id: messageId } }).catch(() => null);
    if (!message) throw new NotFoundException('Message not found');

    await this.logAction(adminId, 'REMOVE_MESSAGE', reason);
    return { message: 'Message successfully deleted', messageId };
  }

  /**
   * Moderate / Cancel Active Challenge
   */
  async moderateChallenge(adminId: string, challengeId: string, reason: string) {
    const db: any = this.prisma;
    const challenge = await db.challenge.update({
      where: { id: challengeId },
      data: { status: 'CANCELLED' },
    }).catch(() => null);
    if (!challenge) throw new NotFoundException('Challenge not found');

    await this.logAction(adminId, 'CANCEL_CHALLENGE', reason);
    return { message: 'Challenge cancelled by moderation', challengeId };
  }

  /**
   * Resolve Dispute
   */
  async resolveDispute(adminId: string, disputeId: string, resolutionNotes: string) {
    const db: any = this.prisma;
    // Assuming a Dispute/Match dispute model exists
    const dispute = await db.dispute.update({
      where: { id: disputeId },
      data: { status: 'RESOLVED', adminNotes: resolutionNotes },
    }).catch(() => null);
    if (!dispute) throw new NotFoundException('Dispute not found');

    await this.logAction(adminId, 'RESOLVE_DISPUTE', resolutionNotes);
    return dispute;
  }

  /**
   * Get Moderation Audit Logs
   */
  async getModerationLogs() {
    const db: any = this.prisma;
    return db.moderationLog.findMany({
      include: {
        admin: { select: { id: true, name: true, username: true, role: true } },
        targetUser: { select: { id: true, name: true, username: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  /**
   * Update Admin Role & Permissions
   */
  async updateAdminRole(adminId: string, targetUserId: string, newRole: 'USER' | 'MODERATOR' | 'ADMIN' | 'SUPER_ADMIN') {
    const db: any = this.prisma;
    const adminUser = await db.user.findUnique({ where: { id: adminId } });
    if (adminUser?.role !== 'SUPER_ADMIN') {
      throw new ForbiddenException('Only Super Admins can assign admin roles');
    }

    return db.user.update({
      where: { id: targetUserId },
      data: { role: newRole },
    });
  }
}