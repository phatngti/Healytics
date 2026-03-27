import { IsBoolean, IsOptional, IsString, Matches } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

/**
 * Represents a single day's work schedule for an employee.
 * Used as an array element in the `schedule` field across all employee DTOs.
 */
export class WorkScheduleEntryDto {
  @ApiProperty({
    example: 'Monday',
    description: 'Day of the week',
    enum: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
  })
  @IsString()
  day: string;

  @ApiPropertyOptional({
    example: '09:00',
    description: 'Work start time in HH:mm format. Empty string if not working.',
  })
  @IsString()
  @IsOptional()
  @Matches(/^([0-1]\d|2[0-3]):[0-5]\d$|^$/, {
    message: 'start must be in HH:mm format or empty string',
  })
  start: string;

  @ApiPropertyOptional({
    example: '17:00',
    description: 'Work end time in HH:mm format. Empty string if not working.',
  })
  @IsString()
  @IsOptional()
  @Matches(/^([0-1]\d|2[0-3]):[0-5]\d$|^$/, {
    message: 'end must be in HH:mm format or empty string',
  })
  end: string;

  @ApiProperty({
    example: true,
    description: 'Whether the employee is working on this day.',
  })
  @IsBoolean()
  isWorking: boolean;
}
