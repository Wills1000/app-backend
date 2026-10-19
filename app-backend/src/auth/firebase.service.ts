import { Injectable, OnModuleInit } from '@nestjs/common';
import * as path from 'path';

// eslint-disable-next-line @typescript-eslint/no-var-requires
const admin = require('firebase-admin');
const { cert, getApp } = require('firebase-admin/app');

@Injectable()
export class FirebaseService implements OnModuleInit {
  onModuleInit() {
    const appInstance = admin.default || admin;
    
    if (!appInstance.apps || appInstance.apps.length === 0) {
      try {
        const serviceAccount = path.resolve(
          process.cwd(),
          'firebase-service-account.json',
        );

        appInstance.initializeApp({
          credential: cert(serviceAccount),
        });
      } catch (error) {
        getApp();
      }
    }
  }

  async verifyToken(idToken: string): Promise<any> {
    const appInstance = admin.default || admin;
    return appInstance.auth().verifyIdToken(idToken);
  }

  async deleteUser(uid: string): Promise<void> {
    const appInstance = admin.default || admin;
    await appInstance.auth().deleteUser(uid);
  }
}
