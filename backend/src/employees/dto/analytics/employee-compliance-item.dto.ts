import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class EmployeeComplianceItemDto {
  @ApiProperty({
    type: String,
    example: 'Verification coverage',
    description: 'Compliance check headline',
  })
  @Expose()
  title: string;

  @ApiProperty({
    type: String,
    example: 'All visible profiles have supporting documents.',
    description: 'Detailed explanation of the compliance status',
  })
  @Expose()
  detail: string;

  @ApiProperty({
    type: String,
    enum: ['neutral', 'positive', 'warning', 'critical'],
    example: 'positive',
    description: 'Severity tone for UI styling',
  })
  @Expose()
  tone: string;
}
