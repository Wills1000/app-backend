import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { FirebaseService } from './firebase.service';

@Injectable()
export class AuthService {
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
      throw new UnauthorizedException('Invalid or expired Firebase token');
    }
  }

  async deleteAccount(userId: string, firebaseUid: string) {
    await this.firebaseService.deleteUser(firebaseUid);
    return this.prisma.user.delete({ where: { id: userId } });
  }
}