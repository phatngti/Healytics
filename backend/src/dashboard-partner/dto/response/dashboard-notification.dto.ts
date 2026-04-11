import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class DashboardNotificationDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @Expose()
  id: string;

  @ApiProperty({ example: 'New Appointment' })
  @Expose()
  title: string;

  @ApiProperty({ example: 'Nguyễn Văn An booked a Full Body Massage.' })
  @Expose()
  message: string;

  @ApiProperty({
    example: 'appointment',
    enum: ['appointment', 'review', 'system', 'alert'],
  })
  @Expose()
  type: string;

  @ApiProperty({ example: '2026-04-09T08:45:00.000Z' })
  @Expose()
  createdAt: string;

  @ApiProperty({ example: false })
  @Expose()
  isRead: boolean;
}
