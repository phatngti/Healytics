import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';
import { PartnerFinanceQueryDto } from './partner-finance-query.dto';

/**
 * Paginated query DTO extending the shared finance filters.
 *
 * Adds `page` (default 1) and `limit` (default 10, max 100).
 */
export class PartnerFinancePageQueryDto extends PartnerFinanceQueryDto {
  @ApiPropertyOptional({ type: Number, default: 1, description: 'Page number (1-indexed)', example: 1 })
  @IsOptional()
  @Type(() => Number)
  @Min(1)
  page?: number = 1;

  @ApiPropertyOptional({ type: Number, default: 10, description: 'Items per page (1-100)', example: 10 })
  @IsOptional()
  @Type(() => Number)
  @Min(1)
  @Max(100)
  limit?: number = 10;
}
