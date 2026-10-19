import { Controller, Post, Patch, Delete, Body, Req, UseGuards } from '@nestjs/common';
import { FcmService } from './fcm.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('fcm')
export class FcmController {
  constructor(private readonly fcmService: FcmService) {}

  @Post('token')
  async registerToken(@Req() req: any, @Body() body: { token: string; deviceType?: string }) {
    const userId = req.user?.id || req.user?.userId;
    return this.fcmService.registerToken(userId, body.token, body.deviceType);
  }

  @Delete('token')
  async removeToken(@Body('token') token: string) {
    return this.fcmService.removeToken(token);
  }

  @Patch('preferences')
  async updatePreferences(@Req() req: any, @Body() body: any) {
    const userId = req.user?.id || req.user?.userId;
    return this.fcmService.updatePreferences(userId, body);
  }
}