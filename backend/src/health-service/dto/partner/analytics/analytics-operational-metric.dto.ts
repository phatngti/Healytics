import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class AnalyticsOperationalMetricDto {
  @ApiProperty({
    type: String,
    example: 'Visibility',
    description: 'Metric label',
  })
  @Expose()
  label: string;

  @ApiProperty({
    type: String,
    example: 'Public',
    description: 'Current metric value',
  })
  @Expose()
  value: string;

  @ApiProperty({
    type: String,
    example: 'Eligible for online discovery',
    description: 'Contextual explanation',
  })
  @Expose()
  detail: string;

  @ApiProperty({
    type: String,
    enum: ['critical', 'warning', 'positive', 'neutral'],
    example: 'positive',
    description: 'Severity tone for UI styling',
  })
  @Expose()
  tone: string;
}
