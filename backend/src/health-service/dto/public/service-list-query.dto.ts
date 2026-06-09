import { Type } from 'class-transformer';
import {
  IsEnum,
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { ApiHideProperty, ApiPropertyOptional } from '@nestjs/swagger';

export enum PublicServiceListSort {
  DEFAULT = 'default',
  PRICE_ASC = 'price_asc',
  PRICE_DESC = 'price_desc',
  RATING_DESC = 'rating_desc',
  LATEST = 'latest',
}

export class PublicServiceListQueryDto {
  @ApiPropertyOptional({ enum: PublicServiceListSort, default: 'default' })
  @IsOptional()
  @IsEnum(PublicServiceListSort)
  sort?: PublicServiceListSort = PublicServiceListSort.DEFAULT;

  @ApiPropertyOptional({ type: Number, minimum: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  minPrice?: number;

  @ApiPropertyOptional({ type: Number, minimum: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  maxPrice?: number;

  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  categoryId?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Clinic name or partial clinic text',
  })
  @IsOptional()
  @IsString()
  @MaxLength(120)
  clinic?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Province/city name or partial text',
  })
  @IsOptional()
  @IsString()
  @MaxLength(120)
  province?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'District name or partial text',
  })
  @IsOptional()
  @IsString()
  @MaxLength(120)
  district?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Ward name or partial text',
  })
  @IsOptional()
  @IsString()
  @MaxLength(120)
  ward?: string;

  @ApiHideProperty()
  @IsOptional()
  @IsString()
  @MaxLength(120)
  clinicId?: string;

  @ApiHideProperty()
  @IsOptional()
  @IsString()
  @MaxLength(120)
  provinceId?: string;

  @ApiHideProperty()
  @IsOptional()
  @IsString()
  @MaxLength(120)
  districtId?: string;

  @ApiHideProperty()
  @IsOptional()
  @IsString()
  @MaxLength(120)
  wardId?: string;

  @ApiPropertyOptional({ type: Number, description: 'User latitude' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  lat?: number;

  @ApiPropertyOptional({ type: Number, description: 'User longitude' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  lng?: number;

  @ApiPropertyOptional({
    type: Number,
    minimum: 1,
    maximum: 50,
    default: 50,
    description: 'Maximum number of services to return',
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(50)
  limit?: number = 50;

  @ApiPropertyOptional({
    type: Number,
    minimum: 0,
    default: 0,
    description: 'Number of services to skip',
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  offset?: number = 0;
}
