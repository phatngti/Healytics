import { registerAs } from '@nestjs/config';

/**
 * Push notification configuration.
 *
 * Mock values are provided by default — replace with real credentials
 * before deploying to production.
 */
export default registerAs('push', () => ({
  fcm: {
    projectId: process.env.FCM_PROJECT_ID || 'mock-project-id',
    privateKey: process.env.FCM_PRIVATE_KEY || 'mock-private-key',
    clientEmail:
      process.env.FCM_CLIENT_EMAIL ||
      'mock@mock.iam.gserviceaccount.com',
  },
  apns: {
    keyId: process.env.APNS_KEY_ID || 'mock-key-id',
    teamId: process.env.APNS_TEAM_ID || 'mock-team-id',
    bundleId: process.env.APNS_BUNDLE_ID || 'com.healytics.app',
    production: process.env.APNS_PRODUCTION === 'true',
  },
}));
