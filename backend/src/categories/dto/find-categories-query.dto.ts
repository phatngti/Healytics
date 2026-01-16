import { IsOptional } from 'class-validator';
import { Transform } from 'class-transformer';
import { ApiPropertyOptional } from '@nestjs/swagger';

/**
 * Query DTO for filtering categories.
 */
export class FindCategoriesQueryDto {
  @ApiPropertyOptional({
    description: 'Return only root categories (without parent)',
    example: true,
  })
  @IsOptional()
  @Transform(({ value }) => value === 'true' || value === true)
  rootsOnly?: boolean;
}
