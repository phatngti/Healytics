import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class ServicePerformanceDto {
  @ApiProperty({ example: 'Full Body Massage' })
  @Expose()
  serviceName: string;

  @ApiProperty({ example: 85 })
  @Expose()
  bookingCount: number;

  @ApiProperty({ example: 12750000, description: 'Total revenue in VND' })
  @Expose()
  revenue: number;

  @ApiProperty({ example: 4.8 })
  @Expose()
  averageRating: number;
}
