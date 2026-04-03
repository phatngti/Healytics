import { ApiProperty } from '@nestjs/swagger';
import { IsDateString } from 'class-validator';

export class CheckDuplicateSlotDto {
  @ApiProperty({
    description: 'Desired slot start time (ISO 8601)',
    example: '2023-10-25T14:00:00Z',
  })
  @IsDateString()
  startTime: string;
}
