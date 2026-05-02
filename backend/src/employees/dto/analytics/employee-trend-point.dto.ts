import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class EmployeeTrendPointDto {
  @ApiProperty({
    type: String,
    example: 'Wk 1',
    description: 'Human-readable x-axis label',
  })
  @Expose()
  label: string;

  @ApiProperty({
    type: Number,
    example: 18,
    description: 'Completed sessions in this time bucket',
  })
  @Expose()
  sessions: number;

  @ApiProperty({
    type: Number,
    example: 9200000,
    description: 'Contribution value in VND for this time bucket',
  })
  @Expose()
  contributionValue: number;
}
