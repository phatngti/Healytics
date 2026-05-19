import { BadRequestException, Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Notification } from '@/common/entities/notification.entity';
import { NotificationRead } from '@/common/entities/notification-read.entity';
import { DeviceToken } from '@/common/entities/device-token.entity';
import { Account } from '@/common/entities/account.entity';
import { NotificationType } from '@/notification/enums/notification-type.enum';
import { DevicePlatform } from '@/notification/enums/device-platform.enum';
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
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
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
      .catch((err: unknown) => {
        const message = err instanceof Error ? err.message : String(err);
        this.logger.error(`Push send failed: ${message}`);
      });

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
    const title = this.normalizeBroadcastText(params.title, 'title');
    const body = this.normalizeBroadcastText(params.body, 'body');

    const dto = await this.createBroadcastHandler.execute({
      ...params,
      title,
      body,
    });

    // Real-time push via WebSocket to all connected users
    this.notificationGateway.pushBroadcast(dto);

    // Push notification to all devices. Provider errors are logged only.
    void Promise.resolve()
      .then(() =>
        this.pushService.sendBroadcast({
          title,
          body,
          data: params.data,
        }),
      )
      .catch((err: unknown) => {
        const message = err instanceof Error ? err.message : String(err);
        this.logger.error(`Broadcast push failed: ${message}`);
      });

    return dto;
  }

  private normalizeBroadcastText(
    value: string,
    fieldName: 'title' | 'body',
  ): string {
    if (typeof value !== 'string') {
      throw new BadRequestException(`${fieldName} must be a string`);
    }

    const trimmed = value.trim();
    if (!trimmed) {
      throw new BadRequestException(`${fieldName} should not be empty`);
    }

    return trimmed;
  }

  // ── Queries ──────────────────────────────────────────────────

  /**
   * Resolves the account creation timestamp for a user.
   *
   * Used as a lower-bound for broadcast queries so that users
   * only see system broadcasts published after they joined.
   * Falls back to Unix epoch when the account is not found.
   */
  private async resolveAccountCreatedAt(userId: string): Promise<Date> {
    // Avoid `select` option in findOne — TypeORM builds a distinctAlias
    // subquery that references `Account_id` which doesn't exist as a column.
    // Using a raw QueryBuilder projection sidesteps the issue entirely.
    const result = await this.accountRepo
      .createQueryBuilder('a')
      .select('a.created_at', 'createdAt')
      .where('a.id = :userId', { userId })
      .getRawOne<{ createdAt: Date }>();
    return result?.createdAt ? new Date(result.createdAt) : new Date(0);
  }

  /**
   * Get paginated notifications for a user (targeted + broadcasts).
   *
   * Broadcasts are filtered to those created on or after the user's
   * account creation date, ensuring new users do not see stale
   * system-wide announcements that predate their registration.
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

    // Resolve the lower-bound date for broadcast visibility
    const accountCreatedAt = await this.resolveAccountCreatedAt(userId);

    // 1. Fetch targeted notifications
    const targetedQb = this.notificationRepo
      .createQueryBuilder('n')
      .where('n.recipientId = :userId', { userId })
      .andWhere('n.isBroadcast = false')
      .andWhere('n.deletedAt IS NULL');

    // 2. Fetch broadcasts relevant to this user's join date
    const broadcastQb = this.notificationRepo
      .createQueryBuilder('n')
      .where('n.isBroadcast = true')
      .andWhere('n.deletedAt IS NULL')
      .andWhere('n.createdAt >= :accountCreatedAt', { accountCreatedAt });

    // Apply cursor
    if (query.cursor) {
      // Avoid `select` with findOne for the same distinctAlias reason;
      // use a raw projection instead.
      const cursorRaw = await this.notificationRepo
        .createQueryBuilder('cn')
        .select('cn.created_at', 'createdAt')
        .where('cn.id = :cursorId', { cursorId: query.cursor })
        .getRawOne<{ createdAt: Date }>();
      if (cursorRaw?.createdAt) {
        const cursorDate = new Date(cursorRaw.createdAt);
        targetedQb.andWhere('n.createdAt < :cursorDate', { cursorDate });
        broadcastQb.andWhere('n.createdAt < :cursorDate', { cursorDate });
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
      targetedQb
        .orderBy('n.createdAt', 'DESC')
        .take(limit + 1)
        .getMany(),
      broadcastQb
        .orderBy('n.createdAt', 'DESC')
        .take(limit + 1)
        .getMany(),
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
      hasMore && result.length > 0 ? result[result.length - 1].id : null;

    return { notifications: result, hasMore, nextCursor };
  }

  /**
   * Get the total unread notification count for a user.
   *
   * Broadcasts are scoped to those published after the user's
   * account creation date, matching the listing behaviour.
   */
  async getUnreadCount(userId: string): Promise<number> {
    const accountCreatedAt = await this.resolveAccountCreatedAt(userId);

    // Count unread targeted notifications
    const targetedCount = await this.notificationRepo.count({
      where: { recipientId: userId, isRead: false },
    });

    // Count unread broadcasts (those NOT in notification_reads for this
    // user) that were created after the user joined
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
      .andWhere('n.createdAt >= :accountCreatedAt', { accountCreatedAt })
      .andWhere('nr.id IS NULL')
      .getCount();

    return targetedCount + unreadBroadcastCount;
  }

  // ── Mutations ────────────────────────────────────────────────

  async markRead(notificationId: string, userId: string): Promise<void> {
    await this.markReadHandler.execute(notificationId, userId);
    const count = await this.getUnreadCount(userId);
    this.notificationGateway.pushUnreadCount(userId, count);
  }

  async markAllRead(userId: string): Promise<{ markedCount: number }> {
    const result = await this.markAllReadHandler.execute(userId);
    const count = await this.getUnreadCount(userId);
    this.notificationGateway.pushUnreadCount(userId, count);
    return result;
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
    platform: DevicePlatform,
  ): Promise<void> {
    // Upsert: if token exists, update user and platform
    const existing = await this.deviceTokenRepo.findOne({
      where: { token },
    });

    if (existing) {
      await this.deviceTokenRepo.update(existing.id, {
        userId,
        platform,
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
          platform,
          isActive: true,
        }),
      );
      this.logger.log(
        `Registered device token: userId=${userId} platform=${platform}`,
      );
    }
  }

  async unregisterDevice(userId: string, token: string): Promise<void> {
    await this.deviceTokenRepo.update({ userId, token }, { isActive: false });
    this.logger.log(`Unregistered device token: ${token.substring(0, 20)}...`);
  }
}
