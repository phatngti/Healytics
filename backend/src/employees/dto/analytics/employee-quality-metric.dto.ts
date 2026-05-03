import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class EmployeeQualityMetricDto {
  @ApiProperty({
    type: String,
    example: 'Client sentiment',
    description: 'Quality metric name',
  })
  @Expose()
  label: string;

  @ApiProperty({
    type: String,
    example: '4.8',
    description: 'Display value (intentionally a string for flexible formatting)',
  })
  @Expose()
  value: string;

  @ApiProperty({
    type: String,
    example: '18 reviews across recent services',
    description: 'Detailed context for the metric',
  })
  @Expose()
  detail: string;

  @ApiProperty({
    type: String,
    enum: ['neutral', 'positive', 'warning', 'critical'],
    example: 'positive',
    description: 'Severity tone for UI styling',
  })
  @Expose()
  tone: string;
}
