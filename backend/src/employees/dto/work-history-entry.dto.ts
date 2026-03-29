import { IsBoolean, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

/**
 * Represents a single work history entry for an employee.
 * Used as an array element in the `workHistory` field across all employee DTOs.
 */
export class WorkHistoryEntryDto {
  @ApiProperty({
    example: 'Glow Saigon Spa Retreat',
    description: 'Facility or organization name',
  })
  @IsString()
  facility: string;

  @ApiProperty({
    example: 'Head of Dermatology',
    description: 'Position or role held',
  })
  @IsString()
  position: string;

  @ApiProperty({
    example: '2022–Present',
    description: 'Employment period',
  })
  @IsString()
  period: string;

  @ApiProperty({
    example: true,
    description: 'Whether this is the current position',
  })
  @IsBoolean()
  isCurrent: boolean;
}
