import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class UpcomingAppointmentDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @Expose()
  id: string;

  @ApiProperty({ example: 'Nguyễn Văn An' })
  @Expose()
  patientName: string;

  @ApiProperty({ example: 'Full Body Massage' })
  @Expose()
  serviceName: string;

  @ApiProperty({ example: 'Dr. Trần Minh' })
  @Expose()
  employeeName: string;

  @ApiProperty({ example: '2026-04-09T09:00:00.000Z' })
  @Expose()
  scheduledAt: string;

  @ApiProperty({
    example: 'confirmed',
    enum: ['confirmed', 'pending'],
    description: 'Mapped from BookingStatus',
  })
  @Expose()
  status: string;
}
