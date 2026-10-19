import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
// Delete or replace this line:
// import * as admin from 'firebase-admin';

// Use this instead:
const admin = require('firebase-admin');

@Injectable()
export class FcmService {
  private readonly logger = new Logger(FcmService.name);

  constructor(private prisma: PrismaService) {
    // Configure FCM using environment variables or a service account JSON file
    if (!admin.apps.length) {
      try {
        admin.initializeApp({
          credential: admin.credential.cert({
            projectId: process.env.FIREBASE_PROJECT_ID,
            clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
            privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
          }),
        });
        this.logger.log('Firebase Cloud Messaging initialized successfully.');
      } catch (error) {
        this.logger.error('Failed to initialize Firebase Admin SDK:', error);
      }
    }
  }

  /**
   * Register or Update a Device Token
   */
  async registerToken(userId: string, token: string, deviceType?: string) {
    const db: any = this.prisma;
    return db.deviceToken.upsert({
      where: { token },
      update: { userId, deviceType, updatedAt: new Date() },
      create: { userId, token, deviceType },
    });
  }

  /**
   * Remove a Device Token (on logout or uninstallation)
   */
  async removeToken(token: string) {
    const db: any = this.prisma;
    try {
      return await db.deviceToken.delete({ where: { token } });
    } catch {
      return { message: 'Token not found or already deleted' };
    }
  }

  /**
   * Update Notification Preferences
   */
  async updatePreferences(userId: string, preferences: { challenges?: boolean; walletUpdates?: boolean; withdrawals?: boolean; messages?: boolean; marketing?: boolean }) {
    const db: any = this.prisma;
    return db.notificationPreference.upsert({
      where: { userId },
      update: preferences,
      create: { userId, ...preferences },
    });
  }

  /**
   * Push Notification Service with Categories, Deep Links, and Preference Filtering
   */
  async sendPushNotification(
    userId: string,
    category: 'CHALLENGE' | 'WALLET' | 'WITHDRAWAL' | 'MESSAGE' | 'MARKETING',
    title: string,
    body: string,
    deepLink?: string,
    additionalData?: Record<string, string>,
  ) {
    const db: any = this.prisma;

    // 1. Check User Notification Preferences
    const prefs = await db.notificationPreference.findUnique({ where: { userId } });
    if (prefs) {
      if (category === 'CHALLENGE' && prefs.challenges === false) return;
      if (category === 'WALLET' && prefs.walletUpdates === false) return;
      if (category === 'WITHDRAWAL' && prefs.withdrawals === false) return;
      if (category === 'MESSAGE' && prefs.messages === false) return;
      if (category === 'MARKETING' && prefs.marketing === false) return;
    }

    // 2. Fetch user's registered device tokens
    const deviceTokens = await db.deviceToken.findMany({ where: { userId } });
    if (!deviceTokens || deviceTokens.length === 0) return;

    const tokens = deviceTokens.map((dt: any) => dt.token);

    // 3. Construct Payload with Deep Links & Categories
    const message: any = {
  tokens,
  notification: { title, body },
  data: {
    category,
    deepLink: deepLink || '',
    ...(additionalData || {}),
  },
  android: { priority: 'high' },
  apns: { payload: { aps: { sound: 'default' } } },
};

    try {
      const response = await admin.messaging().sendEachForMulticast(message);
      this.logger.log(`Push notification sent: ${response.successCount} successful, ${response.failureCount} failed.`);
      
      // Clean up invalid tokens automatically
      if (response.failureCount > 0) {
        response.responses.forEach(async (resp: any, idx: number) => {
          if (!resp.success && (resp.error?.code === 'messaging/invalid-registration-token' || resp.error?.code === 'messaging/registration-token-not-registered')) {
            await this.removeToken(tokens[idx]);
          }
        });
      }
    } catch (error) {
      this.logger.error('Error sending FCM push notification:', error);
    }
  }
}