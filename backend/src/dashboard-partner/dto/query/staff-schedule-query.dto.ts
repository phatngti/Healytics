import { ApiProperty } from '@nestjs/swagger';
import { IsDateString } from 'class-validator';

export class StaffScheduleQueryDto {
  @ApiProperty({
    example: '2026-04-09',
    description: 'Target date for schedule lookup (ISO 8601 date)',
  })
  @IsDateString()
  date: string;
}
