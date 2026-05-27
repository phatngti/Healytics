import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class PartnerFinancePageMetaDto {
  @ApiProperty({ type: Number, example: 1 })
  @Expose()
  page: number;

  @ApiProperty({ type: Number, example: 10 })
  @Expose()
  limit: number;

  @ApiProperty({ type: Number, example: 42 })
  @Expose()
  total: number;

  @ApiProperty({ type: Number, example: 5 })
  @Expose()
  totalPages: number;

  static create(
    total: number,
    page: number,
    limit: number,
  ): PartnerFinancePageMetaDto {
    const dto = new PartnerFinancePageMetaDto();
    dto.page = page;
    dto.limit = limit;
    dto.total = total;
    dto.totalPages = Math.ceil(total / limit) || 1;
    return dto;
  }
}
