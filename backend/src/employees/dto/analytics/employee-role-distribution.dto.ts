import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class EmployeeRoleDistributionDto {
  @ApiProperty({
    type: String,
    example: 'Doctor',
    description: 'Human-readable role label',
  })
  @Expose()
  role: string;

  @ApiProperty({
    type: Number,
    example: 4,
    description: 'Number of employees with this role',
  })
  @Expose()
  count: number;
}
