import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum, IsDateString } from 'class-validator';

/**
 * Revenue period options matching the frontend RevenuePeriod enum.
 */
export enum EmployeeRevenuePeriod {
  DAY = 'day',
  MONTH = 'month',
  YEAR = 'year',
}

/**
 * Query DTO for employee revenue endpoints.
 */
export class EmployeeRevenueQueryDto {
  @ApiPropertyOptional({
    enum: EmployeeRevenuePeriod,
    enumName: 'EmployeeRevenuePeriod',
    default: EmployeeRevenuePeriod.MONTH,
    description: 'Time period for revenue aggregation',
  })
  @IsOptional()
  @IsEnum(EmployeeRevenuePeriod)
  period?: EmployeeRevenuePeriod = EmployeeRevenuePeriod.MONTH;

  @ApiPropertyOptional({
    type: String,
    example: '2026-05-01',
    description: 'Reference date for the period (defaults to today)',
  })
  @IsOptional()
  @IsDateString()
  date?: string;
}
