import { Controller, Get, Patch, Post, Param, Body, UseGuards, Req } from '@nestjs/common';
import { UsersService } from './users.service';
import { FirebaseAuthGuard } from '../auth/guards/firebase-auth.guard';

@Controller('users')
@UseGuards(FirebaseAuthGuard)
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  // Get own full profile
  @Get('profile/me')
  async getOwnProfile(@Req() req: any) {
    return this.usersService.getOwnProfile(req.user.id);
  }

  // Get external player profile
  @Get('profile/:id')
  async getPlayerProfile(@Param('id') id: string) {
    return this.usersService.getPlayerProfile(id);
  }

  // Update profile metadata & gaming credentials
  @Patch('profile/me')
  async updateProfile(@Req() req: any, @Body() body: any) {
    return this.usersService.updateProfile(req.user.id, body);
  }
}