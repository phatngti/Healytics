import { Expose, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Category } from '@/common/entities/category.entity';

/**
 * Summary DTO for nested category relations (parent/children).
 */
class CategorySummaryDto {
  @Expose()
  @ApiProperty({ type: String })
  id: string;

  @Expose()
  @ApiPropertyOptional({ type: String, nullable: true })
  parentId: string | null;

  @Expose()
  @ApiProperty({ type: String })
  name: string;

  @Expose()
  @ApiProperty({ type: String })
  slug: string;

  static fromEntity(entity: Category): CategorySummaryDto {
    const dto = new CategorySummaryDto();
    dto.id = entity.id;
    dto.parentId = entity.parentId;
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
  @ApiProperty({ type: String, description: 'Unique category identifier' })
  id: string;

  @Expose()
  @ApiProperty({ type: String, description: 'Category name' })
  name: string;

  @Expose()
  @ApiProperty({ type: String, description: 'URL-friendly slug' })
  slug: string;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Category description',
  })
  description: string | null;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Category image URL',
  })
  imageUrl: string | null;

  @Expose()
  @ApiProperty({ type: Boolean, description: 'Whether category is active' })
  isActive: boolean;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Parent category ID. Null for root categories.',
  })
  parentId: string | null;

  @Expose()
  @ApiProperty({
    type: Boolean,
    description: 'Whether this category is a root category.',
  })
  isRoot: boolean;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Icon identifier for frontend rendering',
  })
  iconName: string | null;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Hex color value (e.g. #FF6B6B)',
  })
  colorValue: string | null;

  @Expose()
  @ApiProperty({
    type: Number,
    description: 'Sort order for display (lower = first)',
  })
  sortOrder: number;

  @Expose()
  @ApiProperty({
    type: Number,
    description: 'Number of health services in this category',
  })
  serviceCount: number;

  @Expose()
  @ApiProperty({
    type: Number,
    description: 'Number of direct child sub-categories',
  })
  subCategoryCount: number;

  @Expose()
  @ApiProperty({ type: Date, description: 'Creation timestamp' })
  createdAt: Date;

  @Expose()
  @ApiProperty({ type: Date, description: 'Last update timestamp' })
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
    dto.parentId = entity.parentId;
    dto.isRoot = entity.parentId == null;
    dto.iconName = entity.iconName;
    dto.colorValue = entity.colorValue;
    dto.sortOrder = entity.sortOrder;
    dto.serviceCount = entity.serviceCount ?? 0;
    dto.subCategoryCount = entity.children?.length ?? 0;
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
