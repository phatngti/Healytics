import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsBoolean,
  IsOptional,
  IsString,
  IsInt,
  IsEnum,
  IsNumber,
  IsUUID,
  Min,
  Max,
} from 'class-validator';
import { Transform, Type } from 'class-transformer';

export enum ClinicProductSortOption {
  POPULAR = 'popular',
  LATEST = 'latest',
  TOP_SALES = 'top_sales',
  PRICE_ASC = 'price_asc',
  PRICE_DESC = 'price_desc',
}

/**
 * Query DTO for paginated & filtered clinic products listing.
 */
export class GetClinicProductsQueryDto {
  @ApiPropertyOptional({
    description: 'Filter products by category ID',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  categoryId?: string;

  @ApiPropertyOptional({
    description: 'Sort order for products',
    enum: ClinicProductSortOption,
    default: ClinicProductSortOption.POPULAR,
  })
  @IsOptional()
  @IsEnum(ClinicProductSortOption)
  sort?: ClinicProductSortOption;

  @ApiPropertyOptional({ description: 'Case-insensitive service name search' })
  @IsOptional()
  @IsString()
  search?: string;

  @ApiPropertyOptional({ description: 'Minimum current price', minimum: 0 })
  @IsOptional()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  minPrice?: number;

  @ApiPropertyOptional({ description: 'Maximum current price', minimum: 0 })
  @IsOptional()
  @IsNumber()
  @Min(0)
  @Type(() => Number)
  maxPrice?: number;

  @ApiPropertyOptional({
    description: 'Minimum service duration in minutes',
    minimum: 0,
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Type(() => Number)
  minDuration?: number;

  @ApiPropertyOptional({
    description: 'Maximum service duration in minutes',
    minimum: 0,
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Type(() => Number)
  maxDuration?: number;

  @ApiPropertyOptional({ description: 'Only discounted products' })
  @IsOptional()
  @IsBoolean()
  @Transform(({ value }) => value === 'true' || value === true)
  discountOnly?: boolean;

  @ApiPropertyOptional({ default: 1, minimum: 1 })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Type(() => Number)
  page?: number = 1;

  @ApiPropertyOptional({ default: 20, minimum: 1, maximum: 50 })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(50)
  @Type(() => Number)
  limit?: number = 20;
}
