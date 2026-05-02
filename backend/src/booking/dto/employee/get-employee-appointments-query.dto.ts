import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum, IsInt, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';

/**
 * Frontend-facing status filter for employee appointments.
 * Maps to backend BookingStatus values internally.
 */
export enum EmployeeBookingStatusFilter {
  UPCOMING = 'upcoming',
  IN_PROGRESS = 'inProgress',
  COMPLETED = 'completed',
  CANCELED = 'canceled',
}

/**
 * Query DTO for listing employee appointments with optional filtering and pagination.
 */
export class GetEmployeeAppointmentsQueryDto {
  @ApiPropertyOptional({
    enum: EmployeeBookingStatusFilter,
    enumName: 'EmployeeBookingStatusFilter',
    description: 'Filter appointments by status',
  })
  @IsOptional()
  @IsEnum(EmployeeBookingStatusFilter)
  status?: EmployeeBookingStatusFilter;

  @ApiPropertyOptional({ type: Number, default: 1, description: 'Page number' })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number = 1;

  @ApiPropertyOptional({
    type: Number,
    default: 20,
    description: 'Items per page',
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number = 20;
}
