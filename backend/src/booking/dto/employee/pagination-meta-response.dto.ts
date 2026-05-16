import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

/**
 * Pagination metadata for paginated responses.
 */
export class PaginationMetaResponseDto {
  @ApiProperty({ type: Number, example: 1, description: 'Current page number' })
  @Expose()
  page: number;

  @ApiProperty({ type: Number, example: 20, description: 'Items per page' })
  @Expose()
  limit: number;

  @ApiProperty({ type: Number, example: 42, description: 'Total number of items' })
  @Expose()
  total: number;

  @ApiProperty({ type: Number, example: 3, description: 'Total number of pages' })
  @Expose()
  totalPages: number;
}
