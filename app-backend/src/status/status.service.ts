import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { StorageService } from '../storage/storage.service';

@Injectable()
export class StatusService {
  constructor(
    private prisma: PrismaService,
    private storageService: StorageService,
  ) {}

  // 1. Create Status with Multiple Media Items & 24-hour Expiry
  async createStatus(userId: string, files: any[], caption?: string) {
    if (!files || files.length === 0) {
      throw new NotFoundException('At least one media file is required for a status');
    }

    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours from now

    // Upload all files concurrently using our StorageService
    const uploadPromises = files.map(async (file) => {
      const fileTypeCategory = file.mimetype.startsWith('video') ? 'video' : 'image';
      const url = await this.storageService.uploadFile(file, 'statuses', fileTypeCategory, 20);
      return {
        url,
        type: fileTypeCategory.toUpperCase(), // 'IMAGE' or 'VIDEO'
      };
    });

    const mediaItems = await Promise.all(uploadPromises);

    // Create the status record and its media items in Prisma
    return this.prisma.status.create({
      data: {
        userId,
        caption,
        expiresAt,
        media: {
          create: mediaItems,
        },
      },
      include: {
        media: true,
        user: { select: { id: true, name: true, avatar: true } },
      },
    });
  }

  // 2. Get Active Statuses (Excludes expired ones and includes viewed/unviewed state)
  async getActiveStatuses(currentUserId: string) {
    const now = new Date();

    const statuses = await this.prisma.status.findMany({
      where: {
        expiresAt: { gt: now }, // Only non-expired statuses
      },
      include: {
        user: { select: { id: true, name: true, avatar: true } },
        media: true,
        views: { select: { userId: true } },
        reactions: true,
        replies: {
          include: { user: { select: { id: true, name: true, avatar: true } } },
          orderBy: { createdAt: 'asc' },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    // Map through statuses to flag viewed/unviewed state for the current user
    return statuses.map((status) => {
      const hasViewed = status.views.some((view) => view.userId === currentUserId);
      return {
        ...status,
        isViewed: hasViewed,
      };
    });
  }

  // 3. Record Status View
  async recordView(statusId: string, userId: string) {
    return this.prisma.statusView.upsert({
      where: { statusId_userId: { statusId, userId } },
      update: {}, // Do nothing if already viewed
      create: { statusId, userId },
    });
  }

  // 4. Add Reaction to Status
  // 4. Add or Update Reaction to Status
  async addReaction(statusId: string, userId: string, emoji: string) {
    const existing = await this.prisma.statusReaction.findFirst({
      where: { statusId, userId },
    });

    if (existing) {
      return this.prisma.statusReaction.update({
        where: { id: existing.id },
        data: { emoji },
      });
    }

    return this.prisma.statusReaction.create({
      data: { statusId, userId, emoji },
    });
  }

  // 5. Reply to Status
  async addReply(statusId: string, userId: string, message: string) {
    return this.prisma.statusReply.create({
      data: {
        statusId,
        userId,
        message,
      },
      include: { user: { select: { id: true, name: true, avatar: true } } },
    });
  }

  // 6. Delete Status and Clean up Storage
  async deleteStatus(statusId: string, userId: string) {
    const status = await this.prisma.status.findUnique({
      where: { id: statusId },
      include: { media: true },
    });

    if (!status || status.userId !== userId) {
      throw new NotFoundException('Status not found or unauthorized');
    }

    // Delete associated media files from Firebase Storage bucket
    for (const item of status.media) {
      await this.storageService.deleteFile(item.url);
    }

    return this.prisma.status.delete({ where: { id: statusId } });
  }
}