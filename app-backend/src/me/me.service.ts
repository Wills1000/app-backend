import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { StorageService } from '../storage/storage.service';
import { UpdateProfileDto } from './dto/update-profile.dto';
 
const MIN_AGE = 18;
 
@Injectable()
export class MeService {
  constructor(
    private prisma: PrismaService,
    private storage: StorageService,
  ) {}
 
  // The signed-in user with their profile and wallet balances
  async getMe(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        email: true,
        isVerified: true,
        createdAt: true,
        profile: true,
        wallet: {
          select: {
            balance: true,
            availableBalance: true,
            lockedBalance: true,
          },
        },
      },
    });
 
    if (!user) throw new NotFoundException('User not found');
    return user;
  }
 
  async updateProfile(userId: string, dto: UpdateProfileDto) {
    const data: any = { ...dto };
 
    if (dto.dateOfBirth) {
      const dob = new Date(dto.dateOfBirth);
      const now = new Date();
      let age = now.getFullYear() - dob.getFullYear();
      const hadBirthday =
        now.getMonth() > dob.getMonth() ||
        (now.getMonth() === dob.getMonth() && now.getDate() >= dob.getDate());
      if (!hadBirthday) age--;
 
      if (age < MIN_AGE) {
        throw new BadRequestException(
          `You must be at least ${MIN_AGE} years old`,
        );
      }
      data.dateOfBirth = dob;
    }
 
    try {
      return await this.prisma.profile.update({
        where: { userId },
        data,
      });
    } catch (error: any) {
      if (error?.code === 'P2002') {
        throw new ConflictException('That username is already taken');
      }
      if (error?.code === 'P2025') {
        throw new NotFoundException('Profile not found');
      }
      throw error;
    }
  }
 
  async uploadAvatar(userId: string, file: any) {
    if (!file) throw new BadRequestException('No file provided');
 
    // Some clients send images without a proper type: fall back to the file extension
    if (!file.mimetype || !file.mimetype.startsWith('image/')) {
      const ext = (file.originalname?.split('.').pop() || '').toLowerCase();
      const byExtension: Record<string, string> = {
        jpg: 'image/jpeg',
        jpeg: 'image/jpeg',
        png: 'image/png',
        webp: 'image/webp',
        gif: 'image/gif',
      };
      file.mimetype = byExtension[ext] ?? file.mimetype;
    }
 
    const profile = await this.prisma.profile.findUnique({ where: { userId } });
    if (!profile) throw new NotFoundException('Profile not found');
 
    const avatarUrl = await this.storage.uploadFile(
      file,
      `avatars/${userId}`,
      'image',
      5,
    );
 
    await this.prisma.profile.update({
      where: { userId },
      data: { avatarUrl },
    });
 
    // Remove the old picture (best effort)
    if (profile.avatarUrl) {
      await this.storage.deleteFile(profile.avatarUrl);
    }
 
    return { avatarUrl };
  }
}
 