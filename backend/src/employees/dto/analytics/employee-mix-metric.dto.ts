import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class EmployeeMixMetricDto {
  @ApiProperty({
    type: String,
    example: 'Skin Consultation',
    description: 'Service category or product name',
  })
  @Expose()
  label: string;

  @ApiProperty({
    type: Number,
    example: 11,
    description: 'Number of completed sessions for this category',
  })
  @Expose()
  value: number;

  @ApiProperty({
    type: Number,
    example: 0.42,
    description: 'Proportion share (0-1) relative to total sessions',
  })
  @Expose()
  share: number;
}
