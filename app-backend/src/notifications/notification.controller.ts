import { Controller, Get, Post, Patch, Delete, Param, Body, Req, UseGuards } from '@nestjs/common';
import { NotificationService } from './notification.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CreateNotificationDto } from './dto/notification.dto';

@UseGuards(JwtAuthGuard)
@Controller('notifications')
export class NotificationController {
  constructor(private readonly notificationService: NotificationService) {}

  @Get()
  async getMyNotifications(@Req() req: any) {
    const userId = req.user?.id || req.user?.userId;
    return this.notificationService.getUserNotifications(userId);
  }

  @Post()
  async createNotification(@Body() dto: CreateNotificationDto) {
    return this.notificationService.createNotification(dto);
  }

  @Patch(':id/read')
  async markAsRead(@Req() req: any, @Param('id') id: string) {
    const userId = req.user?.id || req.user?.userId;
    return this.notificationService.markAsRead(id, userId);
  }

  @Patch('read-all')
  async markAllAsRead(@Req() req: any) {
    const userId = req.user?.id || req.user?.userId;
    return this.notificationService.markAllAsRead(userId);
  }

  @Delete(':id')
  async deleteNotification(@Req() req: any, @Param('id') id: string) {
    const userId = req.user?.id || req.user?.userId;
    return this.notificationService.deleteNotification(id, userId);
  }
}