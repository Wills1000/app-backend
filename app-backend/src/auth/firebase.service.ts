import { Injectable } from '@nestjs/common';
import { getAuth } from 'firebase-admin/auth';
// Firebase is initialized once, in firebase.config.ts. Importing it here makes sure that has run.
import '../firebase.config';

@Injectable()
export class FirebaseService {
  async verifyToken(idToken: string): Promise<any> {
    return getAuth().verifyIdToken(idToken);
  }

  async deleteUser(uid: string): Promise<void> {
    await getAuth().deleteUser(uid);
  }
}