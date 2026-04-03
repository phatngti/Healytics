import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { NotificationType } from '@/notification/enums/notification-type.enum';
import { WsModel } from '@/common/decorators/ws';

// ─── Server → Client Event Payloads ────────────────────────────

@WsModel({
  description:
    'Server event: a new notification pushed to the user in real-time',
})
export class WsNewNotificationEventDto {
  @ApiProperty({
    description: 'Notification UUID',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  id: string;

  @ApiProperty({
    description: 'The type of notification',
    enum: NotificationType,
    enumName: 'NotificationType',
    example: NotificationType.BOOKING_CONFIRMED,
  })
  type: NotificationType;

  @ApiProperty({
    description: 'Notification title',
    example: 'Booking Confirmed',
  })
  title: string;

  @ApiProperty({
    description: 'Notification body text',
    example: 'Your appointment with Dr. Nguyen has been confirmed.',
  })
  body: string;

  @ApiPropertyOptional({
    description: 'Deep-link data for frontend routing',
    type: 'object',
  })
  data?: Record<string, any> | null;

  @ApiProperty({
    description: 'Whether the notification has been read',
    example: false,
  })
  isRead: boolean;

  @ApiPropertyOptional({
    description: 'When the notification was read',
    type: Date,
  })
  readAt?: Date | null;

  @ApiProperty({
    description: 'Whether this is a system-wide broadcast',
    example: false,
  })
  isBroadcast: boolean;

  @ApiProperty({
    description: 'When the notification was created',
    example: '2026-04-01T00:00:00.000Z',
    type: Date,
  })
  createdAt: Date;
}

@WsModel({
  description: 'Server event: updated unread notification count for the user',
})
export class WsUnreadCountEventDto {
  @ApiProperty({
    description: 'Current unread notification count',
    example: 5,
    type: Number,
  })
  count: number;
}

@WsModel({
  description: 'Server event: a system-wide broadcast was sent (admin-facing)',
})
export class WsBroadcastSentEventDto {
  @ApiProperty({
    description: 'Notification UUID',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  id: string;

  @ApiProperty({
    description: 'Notification title',
    example: 'System Maintenance',
  })
  title: string;

  @ApiProperty({
    description: 'Notification body text',
    example: 'The system will be under maintenance from 2:00 AM to 4:00 AM.',
  })
  body: string;

  @ApiProperty({
    description: 'When the broadcast was created',
    example: '2026-04-01T00:00:00.000Z',
    type: Date,
  })
  createdAt: Date;
}
