import { Injectable, Logger, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { FirebaseService } from './firebase.service';
 
@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);
 
  constructor(
    private prisma: PrismaService,
    private firebaseService: FirebaseService,
  ) {}
 
  async validateAndSyncUser(idToken: string) {
    try {
      const decodedToken = await this.firebaseService.verifyToken(idToken);
      const { uid, email } = decodedToken;
 
      if (!email) {
        throw new UnauthorizedException('Firebase user missing email scope.');
      }
 
      let user = await this.prisma.user.findUnique({
        where: { email },
        include: { profile: true, wallet: true },
      });
 
      if (!user) {
        const defaultUsername = email.split('@')[0] + '_' + uid.slice(0, 5);
        user = await this.prisma.user.create({
          data: {
            email,
            firebaseUid: uid,
            profile: {
              create: {
                username: defaultUsername, 
              },
            },
            wallet: {
              create: {
                availableBalance: 0.00,
              },
            },
          },
          include: { profile: true, wallet: true },
        });
      }
 
      return user;
    } catch (error) {
      // Log the real reason so it shows up in the Render logs (search for "SYNC ERROR")
      this.logger.error(
        `SYNC ERROR: ${(error as any)?.message ?? error}`,
        (error as any)?.stack,
      );
      throw new UnauthorizedException('Invalid or expired Firebase token');
    }
  }
 
  // Checks that a username (and optional phone number) is valid and not already used
  async isUsernameAvailable(username: string, phone?: string) {
    const name = (username ?? '').trim();
 
    if (!/^[a-zA-Z0-9_]{3,20}$/.test(name)) {
      return {
        available: false,
        message: 'Username must be 3-20 characters: letters, numbers or underscore',
      };
    }
 
    const existing = await this.prisma.profile.findFirst({
      where: { username: { equals: name, mode: 'insensitive' } },
      select: { id: true },
    });
 
    if (existing) {
      return { available: false, message: 'That username is already taken' };
    }
 
    if (phone) {
      const cleaned = phone.replace(/[\s\-()]/g, '');
 
      if (!/^\+?[0-9]{7,15}$/.test(cleaned)) {
        return {
          available: false,
          message: 'Enter a valid phone number (7-15 digits)',
        };
      }
 
      const phoneOwner = await this.prisma.user.findFirst({
        where: { phone: cleaned },
        select: { id: true },
      });
 
      if (phoneOwner) {
        return {
          available: false,
          message: 'That phone number is already registered',
        };
      }
    }
 
    return { available: true };
  }
 
  async deleteAccount(userId: string, firebaseUid: string) {
    await this.firebaseService.deleteUser(firebaseUid);
    return this.prisma.user.delete({ where: { id: userId } });
  }
}