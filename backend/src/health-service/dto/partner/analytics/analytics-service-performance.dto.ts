import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class AnalyticsServicePerformanceDto {
  @ApiProperty({
    type: String,
    example: 'Full Body Massage',
  })
  @Expose()
  name: string;

  @ApiProperty({
    type: String,
    example: 'Spa & Wellness',
  })
  @Expose()
  categoryName: string;

  @ApiProperty({ type: Number, example: 85 })
  @Expose()
  bookings: number;

  @ApiProperty({
    type: Number,
    example: 12750000,
    description: 'Revenue in VND',
  })
  @Expose()
  revenue: number;

  @ApiProperty({ type: Number, example: 4.8 })
  @Expose()
  averageRating: number;
}
