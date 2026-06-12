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
 * Category response DTO for API responses.
 * Never expose raw entity data directly.
 */
export class CategoryResponseDto {
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
  @ApiProperty({
    type: Number,
    description: 'Number of direct child sub-categories.',
  })
  subCategoryCount: number;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    description: 'Category type for UI grouping',
    default: 'primary',
  })
  categoryType: string;

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

  static fromEntity(entity: Category): CategoryResponseDto {
    const dto = new CategoryResponseDto();
    dto.id = entity.id;
    dto.name = entity.name;
    dto.slug = entity.slug;
    dto.description = entity.description;
    dto.imageUrl = entity.imageUrl;
    dto.isActive = entity.isActive;
    dto.parentId = entity.parentId;
    dto.isRoot = entity.parentId == null;
    dto.subCategoryCount = entity.children?.length ?? 0;
    dto.categoryType = 'primary';
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    dto.parent = entity.parent
      ? CategorySummaryDto.fromEntity(entity.parent)
      : null;
    dto.children = entity.children?.map(CategorySummaryDto.fromEntity) ?? [];
    return dto;
  }

  static fromEntities(entities: Category[]): CategoryResponseDto[] {
    return entities.map((e) => this.fromEntity(e));
  }
}
