import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsDateString, IsInt, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';

/**
 * Query parameters for the GET /:id/time-slots endpoint.
 */
export class GetTimeSlotsQueryDto {
  @ApiPropertyOptional({
    example: '2026-03-26',
    description: 'Start date for the schedule range (YYYY-MM-DD). Defaults to today.',
  })
  @IsOptional()
  @IsDateString()
  date?: string;

  @ApiPropertyOptional({
    example: 7,
    description: 'Number of days to return from the start date. Default 7, max 30.',
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(30)
  days?: number;
}
