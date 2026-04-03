import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Notification } from '@/common/entities/notification.entity';
import { NotificationRead } from '@/common/entities/notification-read.entity';
import { DeviceToken } from '@/common/entities/device-token.entity';
import { NotificationType } from '@/notification/enums/notification-type.enum';
import { NotificationResponseDto } from '@/notification/dto/notification-response.dto';
import { NotificationsQueryDto } from '@/notification/dto/notifications-query.dto';
import { CreateNotificationHandler } from './application/handlers/create-notification.handler';
import { CreateBroadcastHandler } from './application/handlers/create-broadcast.handler';
import { MarkNotificationReadHandler } from './application/handlers/mark-notification-read.handler';
import { MarkAllReadHandler } from './application/handlers/mark-all-read.handler';
import { NotificationGateway } from './ws/notification.gateway';
import { PushNotificationService } from './push/push-notification.service';

/**
 * Service facade for the Notification module.
 *
 * Coordinates between handlers, the WebSocket gateway, and push services.
 * Controllers and the processor service delegate to this facade.
 */
@Injectable()
export class NotificationService {
  private readonly logger = new Logger(NotificationService.name);

  constructor(
    @InjectRepository(Notification)
    private readonly notificationRepo: Repository<Notification>,
    @InjectRepository(NotificationRead)
    private readonly notifReadRepo: Repository<NotificationRead>,
    @InjectRepository(DeviceToken)
    private readonly deviceTokenRepo: Repository<DeviceToken>,
    private readonly createNotificationHandler: CreateNotificationHandler,
    private readonly createBroadcastHandler: CreateBroadcastHandler,
    private readonly markReadHandler: MarkNotificationReadHandler,
    private readonly markAllReadHandler: MarkAllReadHandler,
    private readonly notificationGateway: NotificationGateway,
    private readonly pushService: PushNotificationService,
  ) {}

  // ── Create + Push (combined for processor) ───────────────────

  /**
   * Create a targeted notification, push via WebSocket, and send push notification.
   */
  async createAndPushNotification(params: {
    recipientId: string;
    type: NotificationType;
    title: string;
    body: string;
    data?: Record<string, any>;
  }): Promise<NotificationResponseDto> {
    const dto = await this.createNotificationHandler.execute(params);

    // Real-time push via WebSocket
    this.notificationGateway.pushToUser(params.recipientId, dto);

    // Update unread count
    const count = await this.getUnreadCount(params.recipientId);
    this.notificationGateway.pushUnreadCount(params.recipientId, count);

    // Push notification for offline users
    this.pushService
      .sendToUser(params.recipientId, {
        title: params.title,
        body: params.body,
        data: params.data,
      })
      .catch((err) =>
        this.logger.error(`Push send failed: ${err.message}`),
      );

    return dto;
  }

  /**
   * Create a broadcast notification, push to all connected users, and send push.
   */
  async createAndPushBroadcast(params: {
    title: string;
    body: string;
    data?: Record<string, any>;
    senderId: string;
  }): Promise<NotificationResponseDto> {
    const dto = await this.createBroadcastHandler.execute(params);

    // Real-time push via WebSocket to all connected users
    this.notificationGateway.pushBroadcast(dto);

    // Push notification to all devices
    this.pushService
      .sendBroadcast({
        title: params.title,
        body: params.body,
        data: params.data,
      })
      .catch((err) =>
        this.logger.error(`Broadcast push failed: ${err.message}`),
      );

    return dto;
  }

  // ── Queries ──────────────────────────────────────────────────

  /**
   * Get paginated notifications for a user (targeted + broadcasts).
   */
  async getNotifications(
    userId: string,
    query: NotificationsQueryDto,
  ): Promise<{
    notifications: NotificationResponseDto[];
    hasMore: boolean;
    nextCursor: string | null;
  }> {
    const limit = query.limit ?? 20;

    // 1. Fetch targeted notifications
    const targetedQb = this.notificationRepo
      .createQueryBuilder('n')
      .where('n.recipientId = :userId', { userId })
      .andWhere('n.isBroadcast = false')
      .andWhere('n.deletedAt IS NULL');

    // 2. Fetch broadcasts (with read status from notification_reads)
    const broadcastQb = this.notificationRepo
      .createQueryBuilder('n')
      .where('n.isBroadcast = true')
      .andWhere('n.deletedAt IS NULL');

    // Apply cursor
    if (query.cursor) {
      const cursorNotif = await this.notificationRepo.findOne({
        where: { id: query.cursor },
        select: ['createdAt'],
      });
      if (cursorNotif) {
        targetedQb.andWhere('n.createdAt < :cursorDate', {
          cursorDate: cursorNotif.createdAt,
        });
        broadcastQb.andWhere('n.createdAt < :cursorDate', {
          cursorDate: cursorNotif.createdAt,
        });
      }
    }

    // Apply type filter
    if (query.type) {
      targetedQb.andWhere('n.type = :type', { type: query.type });
      broadcastQb.andWhere('n.type = :type', { type: query.type });
    }

    // Apply read filter for targeted
    if (query.isRead !== undefined) {
      targetedQb.andWhere('n.isRead = :isRead', { isRead: query.isRead });
    }

    // Execute both queries
    const [targeted, broadcasts] = await Promise.all([
      targetedQb.orderBy('n.createdAt', 'DESC').take(limit + 1).getMany(),
      broadcastQb.orderBy('n.createdAt', 'DESC').take(limit + 1).getMany(),
    ]);

    // For broadcasts, check read status
    const broadcastIds = broadcasts.map((b) => b.id);
    let readBroadcasts: NotificationRead[] = [];
    if (broadcastIds.length > 0) {
      readBroadcasts = await this.notifReadRepo
        .createQueryBuilder('nr')
        .where('nr.notificationId IN (:...ids)', { ids: broadcastIds })
        .andWhere('nr.userId = :userId', { userId })
        .getMany();
    }
    const readBroadcastSet = new Map(
      readBroadcasts.map((r) => [r.notificationId, r.readAt]),
    );

    // Filter broadcasts by read status if requested
    let filteredBroadcasts = broadcasts;
    if (query.isRead !== undefined) {
      filteredBroadcasts = broadcasts.filter((b) => {
        const isRead = readBroadcastSet.has(b.id);
        return query.isRead === isRead;
      });
    }

    // Merge and sort
    const targetedDtos = targeted.map((n) =>
      NotificationResponseDto.fromEntity(n),
    );
    const broadcastDtos = filteredBroadcasts.map((n) =>
      NotificationResponseDto.fromBroadcast(
        n,
        readBroadcastSet.has(n.id),
        readBroadcastSet.get(n.id) ?? null,
      ),
    );

    const merged = [...targetedDtos, ...broadcastDtos]
      .sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime())
      .slice(0, limit + 1);

    const hasMore = merged.length > limit;
    const result = hasMore ? merged.slice(0, limit) : merged;
    const nextCursor =
      hasMore && result.length > 0
        ? result[result.length - 1].id
        : null;

    return { notifications: result, hasMore, nextCursor };
  }

  /**
   * Get the total unread notification count for a user.
   */
  async getUnreadCount(userId: string): Promise<number> {
    // Count unread targeted notifications
    const targetedCount = await this.notificationRepo.count({
      where: { recipientId: userId, isRead: false },
    });

    // Count unread broadcasts (those NOT in notification_reads for this user)
    const unreadBroadcastCount = await this.notificationRepo
      .createQueryBuilder('n')
      .leftJoin(
        NotificationRead,
        'nr',
        'nr.notification_id = n.id AND nr.user_id = :userId',
        { userId },
      )
      .where('n.isBroadcast = true')
      .andWhere('n.deletedAt IS NULL')
      .andWhere('nr.id IS NULL')
      .getCount();

    return targetedCount + unreadBroadcastCount;
  }

  // ── Mutations ────────────────────────────────────────────────

  markRead(notificationId: string, userId: string): Promise<void> {
    return this.markReadHandler.execute(notificationId, userId);
  }

  markAllRead(userId: string): Promise<{ markedCount: number }> {
    return this.markAllReadHandler.execute(userId);
  }

  // ── Broadcast listing (admin) ────────────────────────────────

  async getBroadcasts(): Promise<NotificationResponseDto[]> {
    const broadcasts = await this.notificationRepo.find({
      where: { isBroadcast: true },
      order: { createdAt: 'DESC' },
      take: 50,
    });
    return NotificationResponseDto.fromEntities(broadcasts);
  }

  // ── Device Token Management ──────────────────────────────────

  async registerDevice(
    userId: string,
    token: string,
    platform: string,
  ): Promise<void> {
    // Upsert: if token exists, update user and platform
    const existing = await this.deviceTokenRepo.findOne({
      where: { token },
    });

    if (existing) {
      await this.deviceTokenRepo.update(existing.id, {
        userId,
        platform: platform as any,
        isActive: true,
      });
      this.logger.log(
        `Updated device token: userId=${userId} platform=${platform}`,
      );
    } else {
      await this.deviceTokenRepo.save(
        this.deviceTokenRepo.create({
          userId,
          token,
          platform: platform as any,
          isActive: true,
        }),
      );
      this.logger.log(
        `Registered device token: userId=${userId} platform=${platform}`,
      );
    }
  }

  async unregisterDevice(token: string): Promise<void> {
    await this.deviceTokenRepo.update({ token }, { isActive: false });
    this.logger.log(`Unregistered device token: ${token.substring(0, 20)}...`);
  }
}
