import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class EmployeeDistributionDto {
  @ApiProperty({
    example: 'Doctor',
  })
  @Expose()
  role: string;

  @ApiProperty({ example: 4 })
  @Expose()
  count: number;

  @ApiProperty({ example: 'active' })
  @Expose()
  status: string;
}
