import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Notification } from '@/common/entities/notification.entity';
import { NotificationRead } from '@/common/entities/notification-read.entity';

/**
 * Handler for marking a single notification as read.
 * Handles both targeted notifications and broadcasts.
 */
@Injectable()
export class MarkNotificationReadHandler {
  private readonly logger = new Logger(MarkNotificationReadHandler.name);

  constructor(
    @InjectRepository(Notification)
    private readonly notificationRepo: Repository<Notification>,
    @InjectRepository(NotificationRead)
    private readonly notifReadRepo: Repository<NotificationRead>,
  ) {}

  async execute(notificationId: string, userId: string): Promise<void> {
    const notification = await this.notificationRepo.findOne({
      where: { id: notificationId },
    });

    if (!notification) {
      throw new NotFoundException(
        `Notification with ID ${notificationId} not found`,
      );
    }

    if (notification.isBroadcast) {
      // For broadcasts, insert into notification_reads (idempotent via unique constraint)
      const existing = await this.notifReadRepo.findOne({
        where: { notificationId, userId },
      });

      if (!existing) {
        await this.notifReadRepo.save(
          this.notifReadRepo.create({ notificationId, userId }),
        );
        this.logger.log(
          `Broadcast read: notificationId=${notificationId} userId=${userId}`,
        );
      }
    } else {
      // For targeted notifications, update the row directly
      if (notification.recipientId !== userId) {
        throw new NotFoundException(
          `Notification with ID ${notificationId} not found`,
        );
      }

      if (!notification.isRead) {
        await this.notificationRepo.update(notificationId, {
          isRead: true,
          readAt: new Date(),
        });
        this.logger.log(
          `Notification read: notificationId=${notificationId} userId=${userId}`,
        );
      }
    }
  }
}
