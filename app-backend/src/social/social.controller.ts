// app-backend/src/social/social.controller.ts
import { Controller, Get, Post, Delete, Param, UseGuards, Req } from '@nestjs/common';
import { SocialService } from './social.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Request } from 'express';

@UseGuards(JwtAuthGuard)
@Controller('social')
export class SocialController {
  constructor(private readonly socialService: SocialService) {}

  @Post('follow/:id')
  async follow(@Req() req: Request & { user: { id: string } }, @Param('id') id: string) {
    return this.socialService.followUser(req.user.id, id);
  }

  @Delete('follow/:id')
  async unfollow(@Req() req: Request & { user: { id: string } }, @Param('id') id: string) {
    return this.socialService.unfollowUser(req.user.id, id);
  }

  @Post('friend-request/:id')
  async sendRequest(@Req() req: Request & { user: { id: string } }, @Param('id') id: string) {
    return this.socialService.sendFriendRequest(req.user.id, id);
  }

  @Post('friend-request/:id/accept')
  async acceptRequest(@Req() req: Request & { user: { id: string } }, @Param('id') id: string) {
    return this.socialService.acceptFriendRequest(req.user.id, id);
  }

  @Post('friend-request/:id/reject')
  async rejectRequest(@Req() req: Request & { user: { id: string } }, @Param('id') id: string) {
    return this.socialService.rejectFriendRequest(req.user.id, id);
  }

  @Delete('friend-request/:id')
  async cancelRequest(@Req() req: Request & { user: { id: string } }, @Param('id') id: string) {
    return this.socialService.cancelFriendRequest(req.user.id, id);
  }

  @Delete('friend/:id')
  async removeFriend(@Req() req: Request & { user: { id: string } }, @Param('id') id: string) {
    return this.socialService.removeFriend(req.user.id, id);
  }

  @Get('friends')
  async getFriends(@Req() req: Request & { user: { id: string } }) {
    return this.socialService.getFriends(req.user.id);
  }

  @Get('followers')
  async getFollowers(@Req() req: Request & { user: { id: string } }) {
    return this.socialService.getFollowers(req.user.id);
  }

  @Get('following')
  async getFollowing(@Req() req: Request & { user: { id: string } }) {
    return this.socialService.getFollowing(req.user.id);
  }

  @Post('block/:id')
  async block(@Req() req: Request & { user: { id: string } }, @Param('id') id: string) {
    return this.socialService.blockPlayer(req.user.id, id);
  }

  @Delete('block/:id')
  async unblock(@Req() req: Request & { user: { id: string } }, @Param('id') id: string) {
    return this.socialService.unblockPlayer(req.user.id, id);
  }

  @Post('presence')
  async updatePresence(@Req() req: Request & { user: { id: string } }) {
    return this.socialService.updateLastActive(req.user.id);
  }

  @Get('online')
  async getOnlinePlayers() {
    return this.socialService.getOnlinePlayers();
  }
}