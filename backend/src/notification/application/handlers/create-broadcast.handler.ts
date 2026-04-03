import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Notification } from '@/common/entities/notification.entity';
import { NotificationType } from '@/notification/enums/notification-type.enum';
import { NotificationResponseDto } from '@/notification/dto/notification-response.dto';

/**
 * Handler for creating a system-wide broadcast notification.
 *
 * Broadcasts store a single row with `recipientId = NULL` and `isBroadcast = true`.
 * Per-user read tracking is handled by the NotificationRead entity.
 */
@Injectable()
export class CreateBroadcastHandler {
  private readonly logger = new Logger(CreateBroadcastHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(params: {
    title: string;
    body: string;
    data?: Record<string, any>;
    senderId: string;
  }): Promise<NotificationResponseDto> {
    this.logger.log(
      `Creating broadcast: title="${params.title}" senderId=${params.senderId}`,
    );

    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const notification = queryRunner.manager.create(Notification, {
        recipientId: null,
        type: NotificationType.SYSTEM_BROADCAST,
        title: params.title,
        body: params.body,
        data: params.data ?? null,
        isRead: false,
        isBroadcast: true,
        senderId: params.senderId,
      });

      const saved = await queryRunner.manager.save(Notification, notification);
      await queryRunner.commitTransaction();

      this.logger.log(`Broadcast created: id=${saved.id}`);
      return NotificationResponseDto.fromEntity(saved);
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Failed to create broadcast: ${(error as Error).message}`,
        (error as Error).stack,
      );
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
