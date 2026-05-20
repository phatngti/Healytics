import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsNumber, Min, Max, IsEnum, IsUUID } from 'class-validator';
import { Type } from 'class-transformer';
import { AppointmentStatus } from '../enums/appointment-status.enum';

export enum AppointmentSortOrder {
  /** Newest first (default) */
  NEWEST = 'newest',
  /** Oldest first */
  OLDEST = 'oldest',
}

export class ListAppointmentsQueryDto {
  @ApiPropertyOptional({
    example: 10.7769,
    description: 'User latitude (-90 to 90)',
  })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(-90)
  @Max(90)
  latitude?: number;

  @ApiPropertyOptional({
    example: 106.7009,
    description: 'User longitude (-180 to 180)',
  })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(-180)
  @Max(180)
  longitude?: number;

  @ApiPropertyOptional({
    enum: AppointmentStatus,
    example: AppointmentStatus.UPCOMING,
    description: 'Filter by appointment status',
  })
  @IsOptional()
  @IsEnum(AppointmentStatus)
  status?: AppointmentStatus;

  @ApiPropertyOptional({
    example: '550e8400-e29b-41d4-a716-446655440000',
    description: 'Filter by category ID',
  })
  @IsOptional()
  @IsUUID()
  categoryId?: string;

  @ApiPropertyOptional({
    enum: AppointmentSortOrder,
    default: AppointmentSortOrder.NEWEST,
    description: 'Sort by appointment time: newest (default) or oldest first',
  })
  @IsOptional()
  @IsEnum(AppointmentSortOrder)
  sortBy?: AppointmentSortOrder = AppointmentSortOrder.NEWEST;
}
