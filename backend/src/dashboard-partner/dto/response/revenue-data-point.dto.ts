import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class RevenueDataPointDto {
  @ApiProperty({ example: '2026-04-01T00:00:00.000Z' })
  @Expose()
  date: string;

  @ApiProperty({ example: 1500000, description: 'Revenue amount in VND' })
  @Expose()
  revenue: number;
}
