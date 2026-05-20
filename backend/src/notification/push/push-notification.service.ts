import { Injectable, Logger, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import * as apn from '@parse/node-apn';
import * as admin from 'firebase-admin';
import { readFileSync } from 'fs';
import { Repository } from 'typeorm';
import { DeviceToken } from '@/common/entities/device-token.entity';
import { DevicePlatform } from '@/notification/enums/device-platform.enum';

/**
 * Payload for push notifications sent via FCM/APNs.
 */
export interface PushPayload {
  title: string;
  body: string;
  data?: Record<string, any>;
}

/**
 * Push notification delivery service supporting FCM (Android) and APNs (iOS).
 *
 * Mock configuration provided by default — replace with real credentials
 * in environment variables before deploying.
 *
 * Falls back gracefully when push services are not configured:
 * logs a warning instead of throwing.
 */
@Injectable()
export class PushNotificationService implements OnModuleDestroy {
  private static readonly fcmAppName = 'healytics-push';
  private readonly logger = new Logger(PushNotificationService.name);
  private fcmInitialized = false;
  private apnsInitialized = false;
  private fcmApp?: admin.app.App;
  private apnsProvider?: apn.Provider;

  constructor(
    @InjectRepository(DeviceToken)
    private readonly deviceTokenRepo: Repository<DeviceToken>,
    private readonly configService: ConfigService,
  ) {
    this.initializeFcm();
    this.initializeApns();
  }

  async onModuleDestroy(): Promise<void> {
    await this.apnsProvider?.shutdown();
  }

  // ── Initialization ──────────────────────────────────────────

  private initializeFcm(): void {
    const pushEnabled =
      this.configService.get<boolean>('push.enabled') === true;
    const fcmConfig = this.configService.get('push.fcm');
    const hasCredentials =
      this.isConfiguredSecret(fcmConfig?.projectId) &&
      fcmConfig.projectId !== 'mock-project-id' &&
      this.isConfiguredSecret(fcmConfig?.clientEmail) &&
      fcmConfig.clientEmail !== 'mock@mock.iam.gserviceaccount.com' &&
      (this.isConfiguredPrivateKey(fcmConfig.privateKey) ||
        this.isConfiguredSecret(fcmConfig.privateKeyPath) ||
        this.isConfiguredSecret(fcmConfig.serviceAccountJson));

    if (pushEnabled && hasCredentials) {
      try {
        const serviceAccount = this.buildFirebaseServiceAccount(fcmConfig);
        this.fcmApp = this.resolveFirebaseApp(serviceAccount);
        this.fcmInitialized = true;
        this.logger.log(
          `FCM initialized for project=${serviceAccount.projectId}`,
        );
      } catch (error) {
        this.logger.warn(
          `FCM initialization skipped: ${(error as Error).message}`,
        );
      }
    } else {
      this.logger.warn(
        pushEnabled
          ? 'FCM credentials incomplete — push notifications will be logged only'
          : 'FCM disabled — push notifications will be logged only',
      );
    }
  }

  private initializeApns(): void {
    const pushEnabled =
      this.configService.get<boolean>('push.enabled') === true;
    const apnsConfig = this.configService.get('push.apns');
    const hasCredentials =
      this.isConfiguredSecret(apnsConfig?.keyId) &&
      apnsConfig.keyId !== 'mock-key-id' &&
      this.isConfiguredSecret(apnsConfig?.teamId) &&
      apnsConfig.teamId !== 'mock-team-id' &&
      this.isConfiguredSecret(apnsConfig?.bundleId) &&
      (this.isConfiguredPrivateKey(apnsConfig.privateKey) ||
        this.isConfiguredSecret(apnsConfig.privateKeyPath));

    if (pushEnabled && hasCredentials) {
      try {
        this.apnsProvider = new apn.Provider({
          token: {
            key: this.resolvePrivateKey(
              apnsConfig.privateKey,
              apnsConfig.privateKeyPath,
            ),
            keyId: apnsConfig.keyId,
            teamId: apnsConfig.teamId,
          },
          production: apnsConfig.production === true,
        });
        this.apnsInitialized = true;
        this.logger.log(
          `APNs initialized for bundle=${apnsConfig.bundleId} production=${apnsConfig.production === true}`,
        );
      } catch (error) {
        this.apnsProvider = undefined;
        this.logger.warn(
          `APNs initialization skipped: ${(error as Error).message}`,
        );
      }
    } else {
      this.logger.warn(
        pushEnabled
          ? 'APNs credentials incomplete — push notifications will be logged only'
          : 'APNs disabled — push notifications will be logged only',
      );
    }
  }

  // ── Public API ──────────────────────────────────────────────

  /**
   * Send a push notification to all active devices for a given user.
   */
  async sendToUser(userId: string, payload: PushPayload): Promise<void> {
    const rows = await this.deviceTokenRepo.find({
      where: { userId, isActive: true },
    });

    if (rows.length === 0) {
      this.logger.debug(
        `No active device tokens for userId=${userId} — skipping push`,
      );
      return;
    }

    // Deduplicate by token value — the DB guarantees UQ_DEVICE_TOKEN, but
    // seed data or race conditions can produce multiple rows with the same
    // token string (different platform columns). Without deduplication every
    // duplicate row results in a separate push to the same physical device.
    const seen = new Set<string>();
    const tokens = rows.filter((t) => {
      if (seen.has(t.token)) return false;
      seen.add(t.token);
      return true;
    });

    if (tokens.length < rows.length) {
      this.logger.warn(
        `Deduplicated ${rows.length - tokens.length} duplicate token(s) for userId=${userId} before push`,
      );
    }

    this.logger.log(
      `Sending push to ${tokens.length} device(s) for userId=${userId}`,
    );

    for (const token of tokens) {
      if (await this.shouldSkipToken(token)) {
        continue;
      }

      try {
        if (token.platform === DevicePlatform.IOS) {
          await this.sendApns(token.token, payload);
        } else {
          await this.sendFcm(token.token, payload);
        }
      } catch (error) {
        await this.handlePushError(
          token,
          error,
          `Push failed for token=${token.token.substring(0, 20)}...`,
        );
      }
    }
  }

  /**
   * Send a broadcast push notification to all active device tokens.
   * Used for system-wide announcements.
   */
  async sendBroadcast(payload: PushPayload): Promise<void> {
    const tokenCount = await this.deviceTokenRepo.count({
      where: { isActive: true },
    });

    this.logger.log(`Broadcasting push to ${tokenCount} active device(s)`);

    // Process in batches to avoid memory issues with large user bases
    const batchSize = 500;
    let offset = 0;

    while (offset < tokenCount) {
      const tokens = await this.deviceTokenRepo.find({
        where: { isActive: true },
        skip: offset,
        take: batchSize,
      });

      for (const token of tokens) {
        if (await this.shouldSkipToken(token)) {
          continue;
        }

        try {
          if (token.platform === DevicePlatform.IOS) {
            await this.sendApns(token.token, payload);
          } else {
            await this.sendFcm(token.token, payload);
          }
        } catch (error) {
          await this.handlePushError(
            token,
            error,
            `Broadcast push failed for tokenId=${token.id}`,
          );
        }
      }

      offset += batchSize;
    }
  }

  // ── Private Helpers ─────────────────────────────────────────

  private async shouldSkipToken(token: DeviceToken): Promise<boolean> {
    if (this.isSyntheticToken(token.token)) {
      await this.deactivateDeviceToken(token, 'synthetic mock/seed token');
      return true;
    }

    if (token.platform === DevicePlatform.IOS && !this.apnsInitialized) {
      this.logger.debug(
        `Skipping iOS push for tokenId=${token.id}: APNs is not configured`,
      );
      return true;
    }

    if (token.platform === DevicePlatform.ANDROID && !this.fcmInitialized) {
      this.logger.debug(
        `Skipping Android push for tokenId=${token.id}: FCM is not configured`,
      );
      return true;
    }

    return false;
  }

  private async handlePushError(
    token: DeviceToken,
    error: unknown,
    context: string,
  ): Promise<void> {
    const message = (error as Error)?.message ?? String(error);

    if (this.isInvalidTokenError(error)) {
      await this.deactivateDeviceToken(token, `invalid token: ${message}`);
      this.logger.warn(`${context}: ${message}`);
      return;
    }

    this.logger.error(`${context}: ${message}`);
  }

  private async deactivateDeviceToken(
    token: DeviceToken,
    reason: string,
  ): Promise<void> {
    await this.deviceTokenRepo.update(token.id, { isActive: false });
    this.logger.warn(`Deactivated device token ${token.id}: ${reason}`);
  }

  private async sendFcm(token: string, payload: PushPayload): Promise<void> {
    if (!this.fcmInitialized) {
      this.logger.debug(
        `[FCM MOCK] Would send to token=${token.substring(0, 20)}... title="${payload.title}"`,
      );
      return;
    }

    if (!this.fcmApp) {
      throw new Error('FCM app is not initialized');
    }

    const messageId = await admin.messaging(this.fcmApp).send({
      token,
      notification: { title: payload.title, body: payload.body },
      data: payload.data ? this.stringifyValues(payload.data) : undefined,
      android: {
        priority: 'high',
        notification: {
          channelId: 'healytics_notifications',
          sound: 'default',
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
          },
        },
      },
    });
    this.logger.log(
      `[FCM] Sent to token=${token.substring(0, 20)}... messageId=${messageId}`,
    );
  }

  private async sendApns(token: string, payload: PushPayload): Promise<void> {
    if (!this.apnsInitialized) {
      this.logger.debug(
        `[APNs MOCK] Would send to token=${token.substring(0, 20)}... title="${payload.title}"`,
      );
      return;
    }

    if (!this.apnsProvider) {
      throw new Error('APNs provider is not initialized');
    }

    const notification = new apn.Notification();
    notification.alert = { title: payload.title, body: payload.body };
    notification.topic =
      this.configService.get<string>('push.apns.bundleId') ?? '';
    notification.sound = 'default';
    notification.pushType = 'alert';
    notification.payload = payload.data ?? {};

    const result = await this.apnsProvider.send(notification, token);
    if (result.failed.length > 0) {
      const failure = result.failed[0];
      const reason =
        failure.response?.reason ??
        failure.error?.message ??
        'APNs send failed';
      throw new Error(reason);
    }

    this.logger.log(`[APNs] Sent to token=${token.substring(0, 20)}...`);
  }

  private buildFirebaseServiceAccount(fcmConfig: any): admin.ServiceAccount {
    if (fcmConfig.serviceAccountJson) {
      const parsed = JSON.parse(fcmConfig.serviceAccountJson);
      return {
        projectId: parsed.project_id ?? parsed.projectId,
        clientEmail: parsed.client_email ?? parsed.clientEmail,
        privateKey: this.normalizePrivateKey(
          parsed.private_key ?? parsed.privateKey,
        ),
      };
    }

    return {
      projectId: fcmConfig.projectId,
      clientEmail: fcmConfig.clientEmail,
      privateKey: this.resolvePrivateKey(
        fcmConfig.privateKey,
        fcmConfig.privateKeyPath,
      ),
    };
  }

  private resolveFirebaseApp(
    serviceAccount: admin.ServiceAccount,
  ): admin.app.App {
    const existing = admin.apps.find(
      (app) => app?.name === PushNotificationService.fcmAppName,
    );
    if (existing) {
      return existing;
    }

    return admin.initializeApp(
      {
        credential: admin.credential.cert(serviceAccount),
      },
      PushNotificationService.fcmAppName,
    );
  }

  private resolvePrivateKey(inlineKey?: string, keyPath?: string): string {
    if (keyPath) {
      return readFileSync(keyPath, 'utf8');
    }
    return this.normalizePrivateKey(inlineKey ?? '');
  }

  private normalizePrivateKey(value: string): string {
    return value.replace(/\\n/g, '\n');
  }

  private isConfiguredSecret(value?: string): boolean {
    if (!value || !value.trim()) return false;
    return !/^(your_|YOUR_|\.\.\.)/.test(value.trim());
  }

  private isConfiguredPrivateKey(value?: string): boolean {
    if (!this.isConfiguredSecret(value)) return false;
    const normalized = this.normalizePrivateKey(value ?? '');
    return (
      normalized.includes('-----BEGIN PRIVATE KEY-----') &&
      normalized.includes('-----END PRIVATE KEY-----') &&
      !normalized.includes('YOUR_')
    );
  }

  private stringifyValues(data: Record<string, any>): Record<string, string> {
    return Object.fromEntries(
      Object.entries(data).map(([key, value]) => [
        key,
        typeof value === 'string' ? value : JSON.stringify(value),
      ]),
    );
  }

  private isSyntheticToken(token: string): boolean {
    const normalized = token.trim();
    return (
      normalized.startsWith('mock-fcm-token-') ||
      normalized.startsWith('mock-apns-token-') ||
      normalized.startsWith('SEED_DEVICE_TOKEN')
    );
  }

  private isInvalidTokenError(error: unknown): boolean {
    const message = (error as Error)?.message ?? '';
    const code = (error as { code?: string })?.code ?? '';
    return (
      code === 'messaging/invalid-argument' ||
      code === 'messaging/invalid-registration-token' ||
      code === 'messaging/registration-token-not-registered' ||
      message.includes('InvalidRegistration') ||
      message.includes('NotRegistered') ||
      message.includes('BadDeviceToken') ||
      message.includes('Unregistered') ||
      message.includes('registration-token-not-registered') ||
      message.includes('invalid-registration-token') ||
      message.includes('not a valid FCM registration token')
    );
  }
}
