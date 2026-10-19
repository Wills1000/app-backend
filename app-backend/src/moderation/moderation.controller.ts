import { Controller, Post, Get, Patch, Body, Param, UseGuards, Req } from '@nestjs/common';
import { ModerationService } from './moderation.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('moderation')
@UseGuards(JwtAuthGuard)
export class ModerationController {
  constructor(private readonly moderationService: ModerationService) {}

  @Patch('users/:id/status')
  async updateUserStatus(
    @Req() req: any,
    @Param('id') targetUserId: string,
    @Body() body: { status: 'SUSPENDED' | 'BANNED' | 'ACTIVE'; reason: string },
  ) {
    const adminId = req.user?.id || req.user?.userId;
    return this.moderationService.updateUserStatus(adminId, targetUserId, body.status, body.reason);
  }

  @Post('posts/:id/remove')
  async removePost(@Req() req: any, @Param('id') postId: string, @Body() body: { reason: string }) {
    const adminId = req.user?.id || req.user?.userId;
    return this.moderationService.removePost(adminId, postId, body.reason);
  }

  @Post('messages/:id/remove')
  async removeMessage(@Req() req: any, @Param('id') messageId: string, @Body() body: { reason: string }) {
    const adminId = req.user?.id || req.user?.userId;
    return this.moderationService.removeMessage(adminId, messageId, body.reason);
  }

  @Post('challenges/:id/moderate')
  async moderateChallenge(@Req() req: any, @Param('id') challengeId: string, @Body() body: { reason: string }) {
    const adminId = req.user?.id || req.user?.userId;
    return this.moderationService.moderateChallenge(adminId, challengeId, body.reason);
  }

  @Patch('disputes/:id/resolve')
  async resolveDispute(@Req() req: any, @Param('id') disputeId: string, @Body() body: { resolutionNotes: string }) {
    const adminId = req.user?.id || req.user?.userId;
    return this.moderationService.resolveDispute(adminId, disputeId, body.resolutionNotes);
  }

  @Get('logs')
  async getLogs() {
    return this.moderationService.getModerationLogs();
  }

  @Patch('users/:id/role')
  async updateRole(
    @Req() req: any,
    @Param('id') targetUserId: string,
    @Body() body: { role: 'USER' | 'MODERATOR' | 'ADMIN' | 'SUPER_ADMIN' },
  ) {
    const adminId = req.user?.id || req.user?.userId;
    return this.moderationService.updateAdminRole(adminId, targetUserId, body.role);
  }
}