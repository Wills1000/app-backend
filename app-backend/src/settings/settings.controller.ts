import { Controller, Get, Patch, Post, Delete, Body, Param, UseGuards, Req } from '@nestjs/common';
import { SettingsService } from './settings.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('settings')
@UseGuards(JwtAuthGuard)
export class SettingsController {
  constructor(private readonly settingsService: SettingsService) {}

  @Get()
  async getSettings(@Req() req: any) {
    const userId = req.user?.id || req.user?.userId;
    return this.settingsService.getSettings(userId);
  }

  @Patch()
  async updateSettings(@Req() req: any, @Body() body: Record<string, any>) {
    const userId = req.user?.id || req.user?.userId;
    return this.settingsService.updateSettings(userId, body);
  }

  @Get('blocked')
  async getBlockedUsers(@Req() req: any) {
    const userId = req.user?.id || req.user?.userId;
    return this.settingsService.getBlockedUsers(userId);
  }

  @Post('blocked/:id')
  async blockUser(@Req() req: any, @Param('id') blockedId: string) {
    const userId = req.user?.id || req.user?.userId;
    return this.settingsService.blockUser(userId, blockedId);
  }

  @Delete('blocked/:id')
  async unblockUser(@Req() req: any, @Param('id') blockedId: string) {
    const userId = req.user?.id || req.user?.userId;
    return this.settingsService.unblockUser(userId, blockedId);
  }

  @Delete('account')
  async deleteAccount(@Req() req: any) {
    const userId = req.user?.id || req.user?.userId;
    return this.settingsService.deleteAccount(userId);
  }
}