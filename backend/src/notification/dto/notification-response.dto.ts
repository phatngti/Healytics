import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { NotificationType } from '@/notification/enums/notification-type.enum';
import { Notification } from '@/common/entities/notification.entity';

/**
 * Notification response DTO — returned from all user-facing endpoints.
 */
export class NotificationResponseDto {
  @ApiProperty({ description: 'Notification UUID' })
  @Expose()
  id: string;

  @ApiProperty({
    enum: NotificationType,
    description: 'The type of notification',
  })
  @Expose()
  type: NotificationType;

  @ApiProperty({ description: 'Notification title' })
  @Expose()
  title: string;

  @ApiProperty({ description: 'Notification body text' })
  @Expose()
  body: string;

  @ApiPropertyOptional({
    description: 'Deep-link data for frontend routing',
    type: 'object',
  })
  @Expose()
  data: Record<string, any> | null;

  @ApiProperty({ description: 'Whether the notification has been read' })
  @Expose()
  isRead: boolean;

  @ApiPropertyOptional({ description: 'When the notification was read' })
  @Expose()
  readAt: Date | null;

  @ApiProperty({ description: 'Whether this is a system-wide broadcast' })
  @Expose()
  isBroadcast: boolean;

  @ApiProperty({ description: 'When the notification was created' })
  @Expose()
  createdAt: Date;

  static fromEntity(entity: Notification): NotificationResponseDto {
    const dto = new NotificationResponseDto();
    dto.id = entity.id;
    dto.type = entity.type;
    dto.title = entity.title;
    dto.body = entity.body;
    dto.data = entity.data;
    dto.isRead = entity.isRead;
    dto.readAt = entity.readAt;
    dto.isBroadcast = entity.isBroadcast;
    dto.createdAt = entity.createdAt;
    return dto;
  }

  /**
   * fromEntity variant for broadcast notifications where read status
   * is determined externally (from notification_reads table).
   */
  static fromBroadcast(
    entity: Notification,
    isRead: boolean,
    readAt: Date | null,
  ): NotificationResponseDto {
    const dto = NotificationResponseDto.fromEntity(entity);
    dto.isRead = isRead;
    dto.readAt = readAt;
    return dto;
  }

  static fromEntities(entities: Notification[]): NotificationResponseDto[] {
    return entities.map((e) => this.fromEntity(e));
  }
}
