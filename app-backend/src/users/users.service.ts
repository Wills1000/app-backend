import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  // Create initial profile (Called during initial Auth Sync)
  async createProfile(userId: string, username: string, avatarUrl?: string) {
    return this.prisma.profile.create({
      data: {
        userId,
        username,
        avatarUrl,
      },
    });
  }

  // Get current user's full profile
  async getOwnProfile(userId: string) {
    const profile = await this.prisma.profile.findUnique({
      where: { userId },
      include: { user: { select: { email: true, accountStatus: true, createdAt: true } } },
    });
    if (!profile) throw new NotFoundException('Profile not found');
    return profile;
  }

  // Get public player profile (Respects privacy settings)
  async getPlayerProfile(targetUserId: string) {
    const profile = await this.prisma.profile.findUnique({
      where: { userId: targetUserId },
    });

    if (!profile) throw new NotFoundException('Player profile not found');
     
    // Privacy check
    if (profile.isPrivate) {
      return {
        username: profile.username, 
        avatarUrl: profile.avatarUrl,
        isPrivate: true,
        message: 'This profile is private',
      };
    }

    return profile;
  }

  // Update profile details, gaming IDs, and privacy settings
  async updateProfile(
    userId: string, 
    data: {
      username?: string;
      avatarUrl?: string;
      bio?: string;
      region?: string;
      country?: string;
      gender?: any;
      dateOfBirth?: Date;
      gamingIds?: Record<string, string>;
      isPrivate?: boolean;
    }
  ) {
    return this.prisma.profile.update({
      where: { userId },
      data,
    });
  }
}