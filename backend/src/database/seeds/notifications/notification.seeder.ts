import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Like, Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { Notification } from '@/common/entities/notification.entity';
import { NotificationRead } from '@/common/entities/notification-read.entity';
import { DeviceToken } from '@/common/entities/device-token.entity';
import { NotificationType } from '@/notification/enums/notification-type.enum';
import { DevicePlatform } from '@/notification/enums/device-platform.enum';
import { ISeeder } from '../seeder.interface';
import {
  SEED_MARKERS,
  buildMapBy,
  likePrefix,
  seedKey,
} from '../utils/seed.utils';

interface SeedNotification {
  code: string;
  type: NotificationType;
  title: string;
  body: string;
  recipientEmail: string | null;
  senderEmail: string | null;
  isBroadcast: boolean;
  isRead: boolean;
}

interface SeedDeviceToken {
  code: string;
  userEmail: string;
  platform: DevicePlatform;
  isActive: boolean;
}

const SEED_NOTIFICATIONS: SeedNotification[] = [
  {
    code: 'TARGETED_UNREAD_001',
    type: NotificationType.BOOKING_CONFIRMED,
    title: seedKey(SEED_MARKERS.notificationTitle, 'TARGETED_UNREAD_001'),
    body: 'Your booking has been confirmed. Please complete payment in time.',
    recipientEmail: 'user@healytics.vn',
    senderEmail: null,
    isBroadcast: false,
    isRead: false,
  },
  {
    code: 'TARGETED_READ_001',
    type: NotificationType.APPOINTMENT_REMINDER,
    title: seedKey(SEED_MARKERS.notificationTitle, 'TARGETED_READ_001'),
    body: 'Reminder: your appointment starts in 30 minutes.',
    recipientEmail: 'user@healytics.vn',
    senderEmail: null,
    isBroadcast: false,
    isRead: true,
  },
  {
    code: 'TARGETED_PARTNER_001',
    type: NotificationType.NEW_CHAT_MESSAGE,
    title: seedKey(SEED_MARKERS.notificationTitle, 'TARGETED_PARTNER_001'),
    body: 'A new chat message was received from a user.',
    recipientEmail: 'partner@healytics.vn',
    senderEmail: 'user@healytics.vn',
    isBroadcast: false,
    isRead: false,
  },
  {
    code: 'BROADCAST_001',
    type: NotificationType.SYSTEM_BROADCAST,
    title: seedKey(SEED_MARKERS.notificationTitle, 'BROADCAST_001'),
    body: 'System maintenance is scheduled at 11 PM tonight.',
    recipientEmail: null,
    senderEmail: process.env.DEFAULT_ADMIN_EMAIL || 'admin@healytics.vn',
    isBroadcast: true,
    isRead: false,
  },
  {
    code: 'BROADCAST_002',
    type: NotificationType.SYSTEM_MAINTENANCE,
    title: seedKey(SEED_MARKERS.notificationTitle, 'BROADCAST_002'),
    body: 'Maintenance complete. All services are back online.',
    recipientEmail: null,
    senderEmail: process.env.DEFAULT_ADMIN_EMAIL || 'admin@healytics.vn',
    isBroadcast: true,
    isRead: false,
  },
  {
    code: 'PAYMENT_SUCCESS_DENTAL_001',
    type: NotificationType.PAYMENT_SUCCESS,
    title: seedKey(
      SEED_MARKERS.notificationTitle,
      'PAYMENT_SUCCESS_DENTAL_001',
    ),
    body: 'Payment received for your dental cleaning appointment.',
    recipientEmail: 'nguyenvana@healytics.vn',
    senderEmail: null,
    isBroadcast: false,
    isRead: true,
  },
  {
    code: 'BOOKING_COMPLETED_ACU_001',
    type: NotificationType.BOOKING_COMPLETED,
    title: seedKey(SEED_MARKERS.notificationTitle, 'BOOKING_COMPLETED_ACU_001'),
    body: 'Your acupuncture appointment is complete. You can leave a review.',
    recipientEmail: 'phamthid@healytics.vn',
    senderEmail: null,
    isBroadcast: false,
    isRead: false,
  },
  {
    code: 'BOOKING_CANCELLED_DENTAL_001',
    type: NotificationType.BOOKING_CANCELLED,
    title: seedKey(
      SEED_MARKERS.notificationTitle,
      'BOOKING_CANCELLED_DENTAL_001',
    ),
    body: 'Your dental whitening booking was cancelled and refunded.',
    recipientEmail: 'buithih@healytics.vn',
    senderEmail: null,
    isBroadcast: false,
    isRead: false,
  },
  {
    code: 'PARTNER_VERIFIED_001',
    type: NotificationType.PARTNER_VERIFIED,
    title: seedKey(SEED_MARKERS.notificationTitle, 'PARTNER_VERIFIED_001'),
    body: 'MindSkin Clinic verification was approved.',
    recipientEmail: 'partner6@healytics.vn',
    senderEmail: process.env.DEFAULT_ADMIN_EMAIL || 'admin@healytics.vn',
    isBroadcast: false,
    isRead: false,
  },
  {
    code: 'PAYMENT_FAILED_DERM_001',
    type: NotificationType.PAYMENT_FAILED,
    title: seedKey(SEED_MARKERS.notificationTitle, 'PAYMENT_FAILED_DERM_001'),
    body: 'Payment authorization is still pending for your dermatology consultation.',
    recipientEmail: 'hoangvane@healytics.vn',
    senderEmail: null,
    isBroadcast: false,
    isRead: false,
  },
  {
    code: 'APPOINTMENT_UPDATED_COUNSELING_001',
    type: NotificationType.APPOINTMENT_UPDATED,
    title: seedKey(
      SEED_MARKERS.notificationTitle,
      'APPOINTMENT_UPDATED_COUNSELING_001',
    ),
    body: 'Your counseling room preference has been added to the appointment.',
    recipientEmail: 'vuthif@healytics.vn',
    senderEmail: 'partner6@healytics.vn',
    isBroadcast: false,
    isRead: true,
  },
  {
    code: 'BROADCAST_003',
    type: NotificationType.SYSTEM_BROADCAST,
    title: seedKey(SEED_MARKERS.notificationTitle, 'BROADCAST_003'),
    body: 'New wellness programs are available across dental, nutrition and mental health partners.',
    recipientEmail: null,
    senderEmail: process.env.DEFAULT_ADMIN_EMAIL || 'admin@healytics.vn',
    isBroadcast: true,
    isRead: false,
  },
];

const SEED_DEVICE_TOKENS: SeedDeviceToken[] = [
  {
    code: 'USER_IOS_ACTIVE',
    userEmail: 'user@healytics.vn',
    platform: DevicePlatform.IOS,
    isActive: true,
  },
  {
    code: 'USER_ANDROID_INACTIVE',
    userEmail: 'user@healytics.vn',
    platform: DevicePlatform.ANDROID,
    isActive: false,
  },
  {
    code: 'PARTNER_ANDROID_ACTIVE',
    userEmail: 'partner@healytics.vn',
    platform: DevicePlatform.ANDROID,
    isActive: true,
  },
  {
    code: 'DENTAL_USER_IOS_ACTIVE',
    userEmail: 'nguyenvana@healytics.vn',
    platform: DevicePlatform.IOS,
    isActive: true,
  },
  {
    code: 'MENTAL_USER_ANDROID_ACTIVE',
    userEmail: 'vuthif@healytics.vn',
    platform: DevicePlatform.ANDROID,
    isActive: true,
  },
  {
    code: 'MINDSKIN_PARTNER_IOS_ACTIVE',
    userEmail: 'partner6@healytics.vn',
    platform: DevicePlatform.IOS,
    isActive: true,
  },
];

@Injectable()
export class NotificationSeeder implements ISeeder {
  private readonly logger = new Logger(NotificationSeeder.name);

  constructor(
    @InjectRepository(Notification)
    private readonly notificationRepo: Repository<Notification>,
    @InjectRepository(NotificationRead)
    private readonly notificationReadRepo: Repository<NotificationRead>,
    @InjectRepository(DeviceToken)
    private readonly deviceTokenRepo: Repository<DeviceToken>,
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding notifications...');

    const involvedEmails = [
      ...new Set(
        SEED_NOTIFICATIONS.flatMap((notification) =>
          [notification.recipientEmail, notification.senderEmail].filter(
            (email): email is string => email !== null,
          ),
        ).concat(SEED_DEVICE_TOKENS.map((token) => token.userEmail)),
      ),
    ];
    const accounts = await this.accountRepo.find({
      where: { email: In(involvedEmails) },
      select: ['id', 'email'],
      loadEagerRelations: false,
    });
    const accountMap = buildMapBy(accounts, (account) => account.email);

    await this.seedNotifications(accountMap);
    await this.seedNotificationReads(accountMap);
    await this.seedDeviceTokens(accountMap);

    this.logger.log('Notification seeding completed');
  }

  private async seedNotifications(
    accountMap: Map<string, Account>,
  ): Promise<void> {
    for (const seed of SEED_NOTIFICATIONS) {
      const existing = await this.notificationRepo.findOne({
        where: { title: seed.title },
      });
      if (existing) {
        this.logger.log(
          `  ⏭ Notification "${seed.title}" already exists, skipping`,
        );
        continue;
      }

      const recipientId = seed.recipientEmail
        ? (accountMap.get(seed.recipientEmail)?.id ?? null)
        : null;
      const senderId = seed.senderEmail
        ? (accountMap.get(seed.senderEmail)?.id ?? null)
        : null;

      if (seed.recipientEmail && !recipientId) {
        this.logger.warn(
          `  ⚠ Recipient "${seed.recipientEmail}" not found — skipping`,
        );
        continue;
      }
      if (seed.senderEmail && !senderId) {
        this.logger.warn(
          `  ⚠ Sender "${seed.senderEmail}" not found — skipping`,
        );
        continue;
      }

      await this.notificationRepo.save(
        this.notificationRepo.create({
          recipientId,
          type: seed.type,
          title: seed.title,
          body: seed.body,
          data: { seedKey: seed.code },
          isRead: seed.isRead,
          readAt: seed.isRead ? new Date() : null,
          isBroadcast: seed.isBroadcast,
          senderId,
        }),
      );
      this.logger.log(`  ✅ Created notification "${seed.title}"`);
    }
  }

  private async seedNotificationReads(
    accountMap: Map<string, Account>,
  ): Promise<void> {
    const readTargets: Array<{ notificationCode: string; userEmail: string }> =
      [
        { notificationCode: 'BROADCAST_002', userEmail: 'user@healytics.vn' },
        {
          notificationCode: 'BROADCAST_001',
          userEmail: 'partner@healytics.vn',
        },
        {
          notificationCode: 'BROADCAST_003',
          userEmail: 'nguyenvana@healytics.vn',
        },
        {
          notificationCode: 'BROADCAST_003',
          userEmail: 'partner6@healytics.vn',
        },
      ];

    for (const target of readTargets) {
      const title = seedKey(
        SEED_MARKERS.notificationTitle,
        target.notificationCode,
      );
      const [notification, user] = await Promise.all([
        this.notificationRepo.findOne({
          where: { title },
          select: ['id'],
        }),
        Promise.resolve(accountMap.get(target.userEmail)),
      ]);

      if (!notification || !user) {
        this.logger.warn(
          `  ⚠ Cannot create notification_read for "${title}" and "${target.userEmail}"`,
        );
        continue;
      }

      const existing = await this.notificationReadRepo.findOne({
        where: {
          notificationId: notification.id,
          userId: user.id,
        },
      });
      if (existing) continue;

      await this.notificationReadRepo.save(
        this.notificationReadRepo.create({
          notificationId: notification.id,
          userId: user.id,
        }),
      );
    }
  }

  private async seedDeviceTokens(
    accountMap: Map<string, Account>,
  ): Promise<void> {
    for (const seed of SEED_DEVICE_TOKENS) {
      const user = accountMap.get(seed.userEmail);
      if (!user) {
        this.logger.warn(
          `  ⚠ User "${seed.userEmail}" not found — skipping device token`,
        );
        continue;
      }

      const token = seedKey(SEED_MARKERS.notificationToken, seed.code);
      const existing = await this.deviceTokenRepo.findOne({
        where: { token },
      });
      if (existing) {
        existing.userId = user.id;
        existing.platform = seed.platform;
        existing.isActive = seed.isActive;
        await this.deviceTokenRepo.save(existing);
        this.logger.log(`  🔄 Updated device token "${token}"`);
        continue;
      }

      await this.deviceTokenRepo.save(
        this.deviceTokenRepo.create({
          userId: user.id,
          token,
          platform: seed.platform,
          isActive: seed.isActive,
        }),
      );
      this.logger.log(`  ✅ Created device token "${token}"`);
    }
  }

  async clear(): Promise<void> {
    const seededNotifications = await this.notificationRepo.find({
      where: { title: Like(likePrefix(SEED_MARKERS.notificationTitle)) },
      select: ['id'],
    });

    const notificationIds = seededNotifications.map(
      (notification) => notification.id,
    );
    if (notificationIds.length) {
      const { affected: readAffected } = await this.notificationReadRepo.delete(
        {
          notificationId: In(notificationIds),
        },
      );
      if (readAffected) {
        this.logger.log(
          `🗑️ Hard-deleted ${readAffected} seed notification read row(s)`,
        );
      }

      const { affected: notificationAffected } =
        await this.notificationRepo.delete({
          id: In(notificationIds),
        });
      this.logger.log(
        `🗑️ Hard-deleted ${notificationAffected ?? 0} seed notification(s)`,
      );
    }

    const { affected: tokenAffected } = await this.deviceTokenRepo.delete({
      token: Like(likePrefix(SEED_MARKERS.notificationToken)),
    });
    if (!tokenAffected) {
      this.logger.warn('⚠ No seed device tokens found to delete');
      return;
    }

    this.logger.log(`🗑️ Hard-deleted ${tokenAffected} seed device token(s)`);
  }
}
