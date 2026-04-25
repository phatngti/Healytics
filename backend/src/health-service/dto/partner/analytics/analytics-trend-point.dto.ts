import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class AnalyticsTrendPointDto {
  @ApiProperty({
    type: String,
    example: 'Wk 1',
    description: 'Human-readable x-axis label',
  })
  @Expose()
  label: string;

  @ApiProperty({
    type: Number,
    example: 24,
    description: 'Completed bookings in this time bucket',
  })
  @Expose()
  bookings: number;

  @ApiProperty({
    type: Number,
    example: 4500000,
    description: 'Revenue in VND for this time bucket',
  })
  @Expose()
  revenue: number;
}
