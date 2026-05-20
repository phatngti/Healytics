import { registerAs } from '@nestjs/config';

/**
 * Push notification configuration.
 *
 * Mock values are provided by default — replace with real credentials
 * before deploying to production.
 */
export default registerAs('push', () => ({
  enabled: process.env.PUSH_NOTIFICATIONS_ENABLED === 'true',
  fcm: {
    projectId: process.env.FCM_PROJECT_ID || 'mock-project-id',
    privateKey: process.env.FCM_PRIVATE_KEY || 'mock-private-key',
    privateKeyPath: process.env.FCM_PRIVATE_KEY_PATH || '',
    serviceAccountJson: process.env.FCM_SERVICE_ACCOUNT_JSON || '',
    clientEmail:
      process.env.FCM_CLIENT_EMAIL || 'mock@mock.iam.gserviceaccount.com',
  },
  apns: {
    keyId: process.env.APNS_KEY_ID || 'mock-key-id',
    teamId: process.env.APNS_TEAM_ID || 'mock-team-id',
    bundleId: process.env.APNS_BUNDLE_ID || 'com.healytics.app',
    privateKey: process.env.APNS_PRIVATE_KEY || '',
    privateKeyPath: process.env.APNS_PRIVATE_KEY_PATH || '',
    production: process.env.APNS_PRODUCTION === 'true',
  },
}));
