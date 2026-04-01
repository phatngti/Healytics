import { Expose, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Category } from '@/common/entities/category.entity';

/**
 * Summary DTO for nested category relations (parent/children).
 */
class CategorySummaryDto {
  @Expose()
  @ApiProperty()
  id: string;

  @Expose()
  @ApiProperty()
  name: string;

  @Expose()
  @ApiProperty()
  slug: string;

  static fromEntity(entity: Category): CategorySummaryDto {
    const dto = new CategorySummaryDto();
    dto.id = entity.id;
    dto.name = entity.name;
    dto.slug = entity.slug;
    return dto;
  }
}

/**
 * Admin category response DTO.
 * Includes all fields from CategoryResponseDto plus admin-specific fields:
 * iconName, colorValue, sortOrder, and serviceCount (count of associated products).
 */
export class AdminCategoryResponseDto {
  @Expose()
  @ApiProperty({ description: 'Unique category identifier' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'Category name' })
  name: string;

  @Expose()
  @ApiProperty({ description: 'URL-friendly slug' })
  slug: string;

  @Expose()
  @ApiPropertyOptional({ description: 'Category description' })
  description: string | null;

  @Expose()
  @ApiPropertyOptional({ description: 'Category image URL' })
  imageUrl: string | null;

  @Expose()
  @ApiProperty({ description: 'Whether category is active' })
  isActive: boolean;

  @Expose()
  @ApiPropertyOptional({
    description: 'Icon identifier for frontend rendering',
  })
  iconName: string | null;

  @Expose()
  @ApiPropertyOptional({ description: 'Hex color value (e.g. #FF6B6B)' })
  colorValue: string | null;

  @Expose()
  @ApiProperty({ description: 'Sort order for display (lower = first)' })
  sortOrder: number;

  @Expose()
  @ApiProperty({ description: 'Number of health services in this category' })
  serviceCount: number;

  @Expose()
  @ApiProperty({ description: 'Creation timestamp' })
  createdAt: Date;

  @Expose()
  @ApiProperty({ description: 'Last update timestamp' })
  updatedAt: Date;

  @Expose()
  @Type(() => CategorySummaryDto)
  @ApiPropertyOptional({
    type: CategorySummaryDto,
    description: 'Parent category',
  })
  parent: CategorySummaryDto | null;

  @Expose()
  @Type(() => CategorySummaryDto)
  @ApiPropertyOptional({
    type: [CategorySummaryDto],
    description: 'Child categories',
  })
  children: CategorySummaryDto[];

  static fromEntity(
    entity: Category & { serviceCount?: number },
  ): AdminCategoryResponseDto {
    const dto = new AdminCategoryResponseDto();
    dto.id = entity.id;
    dto.name = entity.name;
    dto.slug = entity.slug;
    dto.description = entity.description;
    dto.imageUrl = entity.imageUrl;
    dto.isActive = entity.isActive;
    dto.iconName = entity.iconName;
    dto.colorValue = entity.colorValue;
    dto.sortOrder = entity.sortOrder;
    dto.serviceCount = entity.serviceCount ?? 0;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    dto.parent = entity.parent
      ? CategorySummaryDto.fromEntity(entity.parent)
      : null;
    dto.children = entity.children?.map(CategorySummaryDto.fromEntity) ?? [];
    return dto;
  }

  static fromEntities(
    entities: (Category & { serviceCount?: number })[],
  ): AdminCategoryResponseDto[] {
    return entities.map((e) => this.fromEntity(e));
  }
}
