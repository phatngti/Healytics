import {
  IsString,
  IsOptional,
  IsBoolean,
  IsNotEmpty,
  IsUUID,
  MaxLength,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateCategoryDto {
  @ApiPropertyOptional({ example: 'uuid-parent-id', description: 'Parent category ID for hierarchical structure' })
  @IsUUID()
  @IsOptional()
  parentId?: string;

  @ApiProperty({ example: 'Massage Services', description: 'Category name' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  name: string;

  @ApiProperty({ example: 'massage-services', description: 'URL-friendly slug (unique)' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  slug: string;

  @ApiPropertyOptional({ example: 'All massage related services', description: 'Category description' })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiPropertyOptional({ example: 'https://example.com/category.jpg', description: 'Category image URL' })
  @IsString()
  @IsOptional()
  @MaxLength(500)
  imageUrl?: string;

  @ApiPropertyOptional({ example: true, description: 'Whether the category is active' })
  @IsBoolean()
  @IsOptional()
  isActive?: boolean;
}
