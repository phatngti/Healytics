import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsUUID, IsDateString, IsOptional } from 'class-validator';

export class MicroLockDto {
  @ApiProperty({ description: 'Staff/employee UUID', example: 'NV_001' })
  @IsUUID()
  staffId: string;

  @ApiProperty({
    description: 'Desired slot start time (ISO 8601)',
    example: '2023-10-25T14:00:00Z',
  })
  @IsDateString()
  startTime: string;

  @ApiPropertyOptional({ description: 'Product/service UUID' })
  @IsUUID()
  @IsOptional()
  productId?: string;
}
