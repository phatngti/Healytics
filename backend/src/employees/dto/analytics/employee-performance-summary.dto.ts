import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class EmployeePerformanceSummaryDto {
  @ApiProperty({
    type: String,
    example: 'Nguyen An',
    description: 'Employee full name',
  })
  @Expose()
  employeeName: string;

  @ApiProperty({
    type: String,
    example: 'Doctor',
    description: 'Human-readable role label',
  })
  @Expose()
  roleLabel: string;

  @ApiProperty({
    type: Number,
    example: 4.9,
    description: 'Average rating (0-5)',
  })
  @Expose()
  rating: number;

  @ApiProperty({
    type: Number,
    example: 82.1,
    description: 'Utilization rate percentage',
  })
  @Expose()
  utilizationRate: number;

  @ApiProperty({
    type: Number,
    example: 14800000,
    description: 'Contribution value in VND',
  })
  @Expose()
  contributionValue: number;
}
