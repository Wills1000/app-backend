import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SettingsService {
  constructor(private prisma: PrismaService) {}

  /**
   * Get User Settings (Auto-initializes defaults if not present)
   */
  async getSettings(userId: string) {
    const db: any = this.prisma;
    let settings = await db.userSettings.findUnique({ where: { userId } });
    
    if (!settings) {
      settings = await db.userSettings.create({
        data: { userId },
      });
    }
    return settings;
  }

  /**
   * Update User Settings (Generic patch for account, privacy, notifications, security, payment, gaming, language, theme)
   */
  async updateSettings(userId: string, data: Record<string, any>) {
    const db: any = this.prisma;
    // Ensure settings record exists first
    await this.getSettings(userId);

    return db.userSettings.update({
      where: { userId },
      data,
    });
  }

  /**
   * Block a Player
   */
  async blockUser(blockerId: string, blockedId: string) {
    const db: any = this.prisma;
    return db.blockedUser.upsert({
      where: { blockerId_blockedId: { blockerId, blockedId } },
      update: {},
      create: { blockerId, blockedId },
    });
  }

  /**
   * Unblock a Player
   */
  async unblockUser(blockerId: string, blockedId: string) {
    const db: any = this.prisma;
    return db.blockedUser.delete({
      where: { blockerId_blockedId: { blockerId, blockedId } },
    }).catch(() => null);
  }

  /**
   * Get Blocked Players List
   */
  async getBlockedUsers(userId: string) {
    const db: any = this.prisma;
    return db.blockedUser.findMany({
      where: { blockerId: userId },
      include: {
        blocked: { select: { id: true, name: true, username: true } },
      },
    });
  }

  /**
   * Secure Account Deletion (Cascades or soft-deletes user account and related records)
   */
  async deleteAccount(userId: string) {
    const db: any = this.prisma;
    const user = await db.user.findUnique({ where: { id: userId } });
    if (!user) throw new NotFoundException('User not found');

    // Deleting user will cascade to settings, wallets, statistics, and relations if configured with onDelete: Cascade
    await db.user.delete({ where: { id: userId } });
    return { message: 'Account and associated settings successfully deleted.' };
  }
}