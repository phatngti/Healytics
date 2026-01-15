import { Expose, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

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
  @ApiProperty({ description: 'Creation timestamp' })
  createdAt: Date;

  @Expose()
  @ApiProperty({ description: 'Last update timestamp' })
  updatedAt: Date;

  @Expose()
  @Type(() => CategorySummaryDto)
  @ApiPropertyOptional({ type: CategorySummaryDto, description: 'Parent category' })
  parent: CategorySummaryDto | null;

  @Expose()
  @Type(() => CategorySummaryDto)
  @ApiPropertyOptional({ type: [CategorySummaryDto], description: 'Child categories' })
  children: CategorySummaryDto[];
}
