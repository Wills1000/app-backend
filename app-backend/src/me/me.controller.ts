import {
  Body,
  Controller,
  Get,
  Patch,
  Post,
  Req,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { FirebaseAuthGuard } from '../auth/guards/firebase-auth.guard';
import { MeService } from './me.service';
import { UpdateProfileDto } from './dto/update-profile.dto';
 
@Controller('me')
@UseGuards(FirebaseAuthGuard)
export class MeController {
  constructor(private readonly meService: MeService) {}
 
  // GET /api/v1/me
  @Get()
  getMe(@Req() req: any) {
    return this.meService.getMe(req.user.id);
  }
 
  // PATCH /api/v1/me/profile
  @Patch('profile')
  updateProfile(@Req() req: any, @Body() dto: UpdateProfileDto) {
    return this.meService.updateProfile(req.user.id, dto);
  }
 
  // POST /api/v1/me/avatar  (multipart form, field name: "file")
  @Post('avatar')
  @UseInterceptors(
    FileInterceptor('file', { limits: { fileSize: 5 * 1024 * 1024 } }),
  )
  uploadAvatar(@Req() req: any, @UploadedFile() file: any) {
    return this.meService.uploadAvatar(req.user.id, file);
  }
}
 