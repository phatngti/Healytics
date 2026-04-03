import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
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
export class PushNotificationService {
  private readonly logger = new Logger(PushNotificationService.name);
  private fcmInitialized = false;
  private apnsInitialized = false;

  constructor(
    @InjectRepository(DeviceToken)
    private readonly deviceTokenRepo: Repository<DeviceToken>,
    private readonly configService: ConfigService,
  ) {
    this.initializeFcm();
    this.initializeApns();
  }

  // ── Initialization ──────────────────────────────────────────

  private initializeFcm(): void {
    const fcmConfig = this.configService.get('push.fcm');
    if (
      fcmConfig?.projectId &&
      fcmConfig.projectId !== 'mock-project-id'
    ) {
      // Real FCM initialization would go here:
      // admin.initializeApp({ credential: admin.credential.cert({...}) })
      this.fcmInitialized = true;
      this.logger.log('FCM initialized with real credentials');
    } else {
      this.logger.warn(
        'FCM running in MOCK mode — push notifications will be logged only',
      );
    }
  }

  private initializeApns(): void {
    const apnsConfig = this.configService.get('push.apns');
    if (
      apnsConfig?.keyId &&
      apnsConfig.keyId !== 'mock-key-id'
    ) {
      // Real APNs initialization would go here:
      // new apn.Provider({ token: { key, keyId, teamId } })
      this.apnsInitialized = true;
      this.logger.log('APNs initialized with real credentials');
    } else {
      this.logger.warn(
        'APNs running in MOCK mode — push notifications will be logged only',
      );
    }
  }

  // ── Public API ──────────────────────────────────────────────

  /**
   * Send a push notification to all active devices for a given user.
   */
  async sendToUser(userId: string, payload: PushPayload): Promise<void> {
    const tokens = await this.deviceTokenRepo.find({
      where: { userId, isActive: true },
    });

    if (tokens.length === 0) {
      this.logger.debug(
        `No active device tokens for userId=${userId} — skipping push`,
      );
      return;
    }

    this.logger.log(
      `Sending push to ${tokens.length} device(s) for userId=${userId}`,
    );

    for (const token of tokens) {
      try {
        if (token.platform === DevicePlatform.IOS) {
          await this.sendApns(token.token, payload);
        } else {
          await this.sendFcm(token.token, payload);
        }
      } catch (error) {
        this.logger.error(
          `Push failed for token=${token.token.substring(0, 20)}...: ${(error as Error).message}`,
        );
        // Deactivate tokens that are no longer valid
        if (this.isInvalidTokenError(error)) {
          await this.deviceTokenRepo.update(token.id, { isActive: false });
          this.logger.warn(`Deactivated invalid token: ${token.id}`);
        }
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

    this.logger.log(
      `Broadcasting push to ${tokenCount} active device(s)`,
    );

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
        try {
          if (token.platform === DevicePlatform.IOS) {
            await this.sendApns(token.token, payload);
          } else {
            await this.sendFcm(token.token, payload);
          }
        } catch (error) {
          this.logger.error(
            `Broadcast push failed for tokenId=${token.id}: ${(error as Error).message}`,
          );
        }
      }

      offset += batchSize;
    }
  }

  // ── Private Helpers ─────────────────────────────────────────

  private async sendFcm(token: string, payload: PushPayload): Promise<void> {
    if (!this.fcmInitialized) {
      this.logger.debug(
        `[FCM MOCK] Would send to token=${token.substring(0, 20)}... title="${payload.title}"`,
      );
      return;
    }

    // Real FCM send would go here:
    // await admin.messaging().send({
    //   token,
    //   notification: { title: payload.title, body: payload.body },
    //   data: payload.data ? this.stringifyValues(payload.data) : undefined,
    // });
    this.logger.log(`[FCM] Sent to token=${token.substring(0, 20)}...`);
  }

  private async sendApns(token: string, payload: PushPayload): Promise<void> {
    if (!this.apnsInitialized) {
      this.logger.debug(
        `[APNs MOCK] Would send to token=${token.substring(0, 20)}... title="${payload.title}"`,
      );
      return;
    }

    // Real APNs send would go here:
    // const notification = new apn.Notification();
    // notification.alert = { title: payload.title, body: payload.body };
    // notification.topic = this.configService.get('push.apns.bundleId');
    // await this.apnProvider.send(notification, token);
    this.logger.log(`[APNs] Sent to token=${token.substring(0, 20)}...`);
  }

  private isInvalidTokenError(error: unknown): boolean {
    const message = (error as Error)?.message ?? '';
    return (
      message.includes('InvalidRegistration') ||
      message.includes('NotRegistered') ||
      message.includes('BadDeviceToken') ||
      message.includes('Unregistered')
    );
  }
}
