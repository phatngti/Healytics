import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsInt,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Max,
  Min,
} from 'class-validator';

export class SeedCouponDto {
  @ApiPropertyOptional({ type: String, description: 'Unique lookup key' })
  @IsOptional()
  @IsString()
  key?: string;

  @ApiProperty({ type: String, example: 'SUMMER20' })
  @IsString()
  @IsNotEmpty()
  code: string;

  @ApiProperty({ type: Number, example: 20 })
  @IsNumber()
  @Min(0)
  @Max(100)
  discountPercent: number;

  @ApiPropertyOptional({ type: Number, example: 100000 })
  @IsOptional()
  @IsNumber()
  @Min(0)
  maxDiscountAmount?: number;

  @ApiPropertyOptional({ type: Number, example: 50 })
  @IsOptional()
  @IsInt()
  @Min(1)
  usageLimit?: number;

  @ApiPropertyOptional({
    type: String,
    description: 'Key of a previously seeded service',
  })
  @IsOptional()
  @IsString()
  serviceKey?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Slug to look up the service',
  })
  @IsOptional()
  @IsString()
  serviceSlug?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Category name (auto-created if missing)',
  })
  @IsOptional()
  @IsString()
  categoryName?: string;

  @ApiPropertyOptional({
    type: String,
    example: '2026-12-31T23:59:59Z',
    description: 'ISO 8601 expiry',
  })
  @IsOptional()
  @IsString()
  expiresAt?: string;
}
