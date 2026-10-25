const fs = require('fs');
const path = require('path');
const { getApps, initializeApp, cert } = require('firebase-admin/app');
const { getAuth } = require('firebase-admin/auth');
const { getMessaging } = require('firebase-admin/messaging');
 
// On Render the file is stored as a Secret File at /etc/secrets/.
// Locally it is read from the project folder, as before.
const renderSecretPath = '/etc/secrets/firebase-service-account.json';
const localPath = path.resolve(process.cwd(), 'firebase-service-account.json');
 
const serviceAccountPath = fs.existsSync(renderSecretPath)
  ? renderSecretPath
  : localPath;
 
const serviceAccount = JSON.parse(fs.readFileSync(serviceAccountPath, 'utf8'));
 
if (!getApps().length) {
  initializeApp({
    credential: cert(serviceAccount),
    // Set FIREBASE_STORAGE_BUCKET to the exact bucket name shown in Firebase Console > Storage.
    storageBucket:
      process.env.FIREBASE_STORAGE_BUCKET ||
      `${serviceAccount.project_id}.appspot.com`,
  });
}
 
// Same shape as before, so existing code like firebaseAdmin.auth() keeps working.
export const firebaseAdmin = {
  auth: () => getAuth(),
  messaging: () => getMessaging(),
};
 