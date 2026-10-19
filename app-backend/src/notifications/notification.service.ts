import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateNotificationDto } from './dto/notification.dto';

@Injectable()
export class NotificationService {
  constructor(private prisma: PrismaService) {}

  /**
   * Create a notification (Internal helper or Controller action)
   */
  async createNotification(dto: CreateNotificationDto) {
    const db: any = this.prisma;
    return db.notification.create({
      data: {
        userId: dto.userId,
        title: dto.title,
        message: dto.message,
        type: dto.type,
        metadata: dto.metadata || {},
      },
    });
  }

  /**
   * Get all notifications for a user (paginated or sorted by recent)
   */
  async getUserNotifications(userId: string) {
    const db: any = this.prisma;
    return db.notification.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      take: 50,
    });
  }

  /**
   * Mark a single notification as read
   */
  async markAsRead(notificationId: string, userId: string) {
    const db: any = this.prisma;
    const notification = await db.notification.findFirst({
      where: { id: notificationId, userId },
    });
    if (!notification) throw new NotFoundException('Notification not found');

    return db.notification.update({
      where: { id: notificationId },
      data: { isRead: true },
    });
  }

  /**
   * Mark all notifications as read for a user
   */
  async markAllAsRead(userId: string) {
    const db: any = this.prisma;
    return db.notification.updateMany({
      where: { userId, isRead: false },
      data: { isRead: true },
    });
  }

  /**
   * Delete a notification
   */
  async deleteNotification(notificationId: string, userId: string) {
    const db: any = this.prisma;
    const notification = await db.notification.findFirst({
      where: { id: notificationId, userId },
    });
    if (!notification) throw new NotFoundException('Notification not found');

    return db.notification.delete({
      where: { id: notificationId },
    });
  }
}