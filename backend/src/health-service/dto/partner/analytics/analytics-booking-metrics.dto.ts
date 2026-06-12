import { ApiProperty } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { AnalyticsAlertDto } from './analytics-alert.dto';

export class BookingStatusBreakdownDto {
  @ApiProperty({
    type: String,
    example: 'confirmed',
    description: 'Machine-readable status key: confirmed, cancelled, no_show',
  })
  @Expose()
  statusKey: string;

  @ApiProperty({
    type: String,
    example: 'Confirmed',
    description: 'Human-readable label',
  })
  @Expose()
  label: string;

  @ApiProperty({ type: Number, example: 18 })
  @Expose()
  count: number;
}

export class AnalyticsBookingMetricsDto {
  @ApiProperty({ type: Number, example: 120 })
  @Expose()
  totalBookings: number;

  @ApiProperty({
    type: Number,
    example: 5,
    description: 'Bookings exceeding delay threshold',
  })
  @Expose()
  delayedBookings: number;

  @ApiProperty({
    type: Number,
    example: 15,
    description: 'Delay threshold in minutes',
  })
  @Expose()
  delayThresholdMinutes: number;

  @ApiProperty({
    type: Number,
    example: 14,
    description: 'PENDING_PAYMENT + CONFIRMED bookings',
  })
  @Expose()
  pendingBookings: number;

  @ApiProperty({ type: Number, example: 85 })
  @Expose()
  completedBookings: number;

  @ApiProperty({
    type: [BookingStatusBreakdownDto],
    description: 'Per-status counts',
  })
  @Expose()
  @Type(() => BookingStatusBreakdownDto)
  statusBreakdown: BookingStatusBreakdownDto[];

  @ApiProperty({
    type: [AnalyticsAlertDto],
    description: 'Operational alerts for booking health',
  })
  @Expose()
  @Type(() => AnalyticsAlertDto)
  alerts: AnalyticsAlertDto[];
}
