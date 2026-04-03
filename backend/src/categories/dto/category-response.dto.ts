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
 * Category response DTO for API responses.
 * Never expose raw entity data directly.
 */
export class CategoryResponseDto {
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
    description: 'Category type for UI grouping',
    default: 'primary',
  })
  categoryType: string;

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

  static fromEntity(entity: Category): CategoryResponseDto {
    const dto = new CategoryResponseDto();
    dto.id = entity.id;
    dto.name = entity.name;
    dto.slug = entity.slug;
    dto.description = entity.description;
    dto.imageUrl = entity.imageUrl;
    dto.isActive = entity.isActive;
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
