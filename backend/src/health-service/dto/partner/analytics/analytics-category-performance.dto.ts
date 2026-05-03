import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class AnalyticsCategoryPerformanceDto {
  @ApiProperty({
    type: String,
    example: 'Spa & Wellness',
  })
  @Expose()
  categoryName: string;

  @ApiProperty({ type: Number, example: 45 })
  @Expose()
  bookings: number;

  @ApiProperty({
    type: Number,
    example: 12750000,
    description: 'Revenue in VND',
  })
  @Expose()
  revenue: number;

  @ApiProperty({ type: Number, example: 4.6 })
  @Expose()
  averageRating: number;
}
