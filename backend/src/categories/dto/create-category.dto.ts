import {
  IsString,
  IsOptional,
  IsBoolean,
  IsNotEmpty,
  IsUUID,
  IsInt,
  Min,
  MaxLength,
  Matches,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateCategoryDto {
  @ApiPropertyOptional({
    example: 'uuid-parent-id',
    description: 'Parent category ID for hierarchical structure',
  })
  @IsUUID()
  @IsOptional()
  parentId?: string;

  @ApiProperty({ example: 'Massage Services', description: 'Category name' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  name: string;

  @ApiProperty({
    example: 'massage-services',
    description: 'URL-friendly slug (unique)',
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  slug: string;

  @ApiPropertyOptional({
    example: 'All massage related services',
    description: 'Category description',
  })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiPropertyOptional({
    example: 'https://example.com/category.jpg',
    description: 'Category image URL',
  })
  @IsString()
  @IsOptional()
  @MaxLength(500)
  imageUrl?: string;

  @ApiPropertyOptional({
    example: true,
    description: 'Whether the category is active',
  })
  @IsBoolean()
  @IsOptional()
  isActive?: boolean;

  @ApiPropertyOptional({
    example: 'spa',
    description: 'Icon identifier for frontend rendering',
  })
  @IsString()
  @IsOptional()
  @MaxLength(100)
  iconName?: string;

  @ApiPropertyOptional({
    example: '#FF6B6B',
    description: 'Hex color value (e.g. #FF6B6B or #FF6B6BCC)',
  })
  @IsString()
  @IsOptional()
  @Matches(/^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$/, {
    message: 'colorValue must be a valid hex color (#RRGGBB or #RRGGBBAA)',
  })
  colorValue?: string;

  @ApiPropertyOptional({
    example: 0,
    description: 'Sort order for display (lower = first)',
  })
  @IsInt()
  @Min(0)
  @IsOptional()
  sortOrder?: number;
}
