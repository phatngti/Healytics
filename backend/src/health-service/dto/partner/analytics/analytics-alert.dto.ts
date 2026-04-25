import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class AnalyticsAlertDto {
  @ApiProperty({
    type: String,
    example: 'Delayed bookings need intervention',
    description: 'Alert headline',
  })
  @Expose()
  title: string;

  @ApiProperty({
    type: String,
    example: '3 bookings are running more than 15 minutes behind schedule.',
    description: 'Detailed explanation of the alert',
  })
  @Expose()
  detail: string;

  @ApiProperty({
    type: String,
    enum: ['critical', 'warning', 'positive', 'neutral'],
    example: 'critical',
    description: 'Severity tone for UI styling',
  })
  @Expose()
  tone: string;
}
