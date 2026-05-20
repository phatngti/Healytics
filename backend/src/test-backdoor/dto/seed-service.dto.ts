import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsArray,
  IsInt,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Min,
} from 'class-validator';

export class SeedServiceDto {
  @ApiPropertyOptional({ type: String, description: 'Unique lookup key' })
  @IsOptional()
  @IsString()
  key?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Key of a previously seeded partner',
  })
  @IsOptional()
  @IsString()
  partnerKey?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Brand name to look up the partner',
  })
  @IsOptional()
  @IsString()
  partnerBrandName?: string;

  @ApiPropertyOptional({
    type: [String],
    description: 'Keys of previously seeded employees',
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  employeeKeys?: string[];

  @ApiPropertyOptional({
    type: String,
    description: 'Key of a previously seeded category',
  })
  @IsOptional()
  @IsString()
  categoryKey?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Category name (auto-created if missing)',
  })
  @IsOptional()
  @IsString()
  categoryName?: string;

  @ApiProperty({ type: String, example: 'Deep Tissue Massage' })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiPropertyOptional({ type: String, example: 'deep-tissue-massage' })
  @IsOptional()
  @IsString()
  slug?: string;

  @ApiPropertyOptional({ type: String })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional({ type: Number, example: 500000 })
  @IsOptional()
  @IsNumber()
  @Min(0)
  price?: number;

  @ApiPropertyOptional({ type: Number, example: 60 })
  @IsOptional()
  @IsInt()
  @Min(1)
  durationMinutes?: number;

  @ApiPropertyOptional({ type: String })
  @IsOptional()
  @IsString()
  vendorName?: string;
}
