import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsDateString,
  IsEnum,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  Min,
} from 'class-validator';
import { Type } from 'class-transformer';

export enum RecentActivitySort {
  DEFAULT = 'default',
  DATE_ASC = 'date_asc',
  DATE_DESC = 'date_desc',
}

export class RecentActivityQueryDto {
  @ApiPropertyOptional({
    example: 5,
    description: 'Maximum number of items to return (1–20)',
    default: 5,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(20)
  limit?: number = 5;

  @ApiPropertyOptional({
    example: 0,
    description: 'Number of items to skip',
    default: 0,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  offset?: number = 0;

  @ApiPropertyOptional({ example: 'completed' })
  @IsOptional()
  @IsString()
  status?: string;

  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  categoryId?: string;

  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  clinicId?: string;

  @ApiPropertyOptional({ example: '2026-05-01' })
  @IsOptional()
  @IsDateString()
  fromDate?: string;

  @ApiPropertyOptional({ example: '2026-05-31' })
  @IsOptional()
  @IsDateString()
  toDate?: string;

  @ApiPropertyOptional({ enum: RecentActivitySort, default: 'default' })
  @IsOptional()
  @IsEnum(RecentActivitySort)
  sort?: RecentActivitySort = RecentActivitySort.DEFAULT;
}
