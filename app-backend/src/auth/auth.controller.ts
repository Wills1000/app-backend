import { Controller, Post, Delete, UseGuards, Req, Body } from '@nestjs/common';
import { AuthService } from './auth.service';
import { VerificationService } from './verification.service';
import { VerifyCodeDto } from './dto/verify-code.dto';
import { FirebaseAuthGuard } from './guards/firebase-auth.guard';
 
@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly verificationService: VerificationService,
  ) {}
 
  @Post('sync')
  @UseGuards(FirebaseAuthGuard)
  async syncUser(@Req() req: any) {
    return req.user;
  }
 
  // Sends a 6-digit code to the signed-in user's email
  @Post('send-code')
  @UseGuards(FirebaseAuthGuard)
  async sendCode(@Req() req: any) {
    return this.verificationService.sendCode(req.user);
  }
 
  // Checks the code and marks the user's email as verified
  @Post('verify-code')
  @UseGuards(FirebaseAuthGuard)
  async verifyCode(@Req() req: any, @Body() body: VerifyCodeDto) {
    return this.verificationService.verifyCode(req.user, body.code);
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
 