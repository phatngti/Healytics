import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsOptional,
  IsString,
  IsArray,
  MaxLength,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { WorkScheduleEntryDto } from '../work-schedule-entry.dto';

/**
 * DTO for employee self-service profile updates.
 * Only fields that an employee is allowed to change are included.
 * Admin/partner-only fields (role, status, employeeCode, partnerId, jobTitle)
 * are intentionally excluded.
 */
export class UpdateEmployeeProfileDto {
  @ApiPropertyOptional({ type: String, example: '0901234567' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  phone?: string;

  @ApiPropertyOptional({
    type: String,
    example: 'https://cdn.example.com/avatar.jpg',
  })
  @IsOptional()
  @IsString()
  avatarUrl?: string;

  @ApiPropertyOptional({
    type: String,
    example: 'Experienced massage therapist with 5+ years...',
  })
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  description?: string;

  @ApiPropertyOptional({ type: String, example: 'Jane Doe' })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  emergencyContactName?: string;

  @ApiPropertyOptional({ type: String, example: '0987654321' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  emergencyContactPhone?: string;

  @ApiPropertyOptional({
    type: [WorkScheduleEntryDto],
    description: 'Weekly work schedule',
  })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => WorkScheduleEntryDto)
  schedule?: WorkScheduleEntryDto[];
}
