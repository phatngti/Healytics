import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Notification } from '@/common/entities/notification.entity';
import { NotificationRead } from '@/common/entities/notification-read.entity';
import { Account } from '@/common/entities/account.entity';

/**
 * Handler for marking all unread notifications as read for a user.
 * Handles both targeted notifications and broadcast read tracking.
 */
@Injectable()
export class MarkAllReadHandler {
  private readonly logger = new Logger(MarkAllReadHandler.name);

  constructor(
    @InjectRepository(Notification)
    private readonly notificationRepo: Repository<Notification>,
    @InjectRepository(NotificationRead)
    private readonly notifReadRepo: Repository<NotificationRead>,
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
  ) {}

  async execute(userId: string): Promise<{ markedCount: number }> {
    this.logger.log(`Marking all notifications as read for userId=${userId}`);

    // Resolve join date so we only touch broadcasts this user can see
    const account = await this.accountRepo.findOne({
      where: { id: userId },
      select: ['createdAt'],
    });
    const accountCreatedAt = account?.createdAt ?? new Date(0);

    // 1. Mark all targeted unread notifications as read
    const targetedResult = await this.notificationRepo.update(
      { recipientId: userId, isRead: false },
      { isRead: true, readAt: new Date() },
    );

    // 2. Find unread broadcasts published after the user's join date
    const unreadBroadcasts = await this.notificationRepo
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
      .getMany();

    // 3. Insert read records for unread broadcasts
    if (unreadBroadcasts.length > 0) {
      const readRecords = unreadBroadcasts.map((b) =>
        this.notifReadRepo.create({
          notificationId: b.id,
          userId,
        }),
      );
      await this.notifReadRepo.save(readRecords);
    }

    const total =
      (targetedResult.affected ?? 0) + unreadBroadcasts.length;
    this.logger.log(
      `Marked ${total} notifications as read for userId=${userId}`,
    );

    return { markedCount: total };
  }
}
