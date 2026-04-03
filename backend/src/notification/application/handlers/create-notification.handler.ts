import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Notification } from '@/common/entities/notification.entity';
import { NotificationType } from '@/notification/enums/notification-type.enum';
import { NotificationResponseDto } from '@/notification/dto/notification-response.dto';

/**
 * Handler for creating and persisting a single targeted notification.
 * Owns the transaction lifecycle per project conventions.
 */
@Injectable()
export class CreateNotificationHandler {
  private readonly logger = new Logger(CreateNotificationHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(params: {
    recipientId: string;
    type: NotificationType;
    title: string;
    body: string;
    data?: Record<string, any>;
  }): Promise<NotificationResponseDto> {
    this.logger.log(
      `Creating notification: type=${params.type} recipientId=${params.recipientId}`,
    );

    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const notification = queryRunner.manager.create(Notification, {
        recipientId: params.recipientId,
        type: params.type,
        title: params.title,
        body: params.body,
        data: params.data ?? null,
        isRead: false,
        isBroadcast: false,
      });

      const saved = await queryRunner.manager.save(Notification, notification);
      await queryRunner.commitTransaction();

      this.logger.log(
        `Notification created: id=${saved.id} type=${saved.type}`,
      );
      return NotificationResponseDto.fromEntity(saved);
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Failed to create notification: ${(error as Error).message}`,
        (error as Error).stack,
      );
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
