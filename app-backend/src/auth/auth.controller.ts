import { Controller, Post, Delete, UseGuards, Req } from '@nestjs/common';
import { AuthService } from './auth.service';
import { FirebaseAuthGuard } from './guards/firebase-auth.guard';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('sync')
  @UseGuards(FirebaseAuthGuard)
  async syncUser(@Req() req: any) {
    return req.user;
  }

  @Post('logout')
  @UseGuards(FirebaseAuthGuard)
  async logout() {
    return { message: 'Logged out successfully' };
  }

  @Delete('account')
  @UseGuards(FirebaseAuthGuard)
  async deleteAccount(@Req() req: any) {
    return this.authService.deleteAccount(req.user.id, req.user.firebaseUid);
  }
}