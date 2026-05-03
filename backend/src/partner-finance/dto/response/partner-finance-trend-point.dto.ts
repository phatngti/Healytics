import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class PartnerFinanceTrendPointDto {
  @ApiProperty({ type: String, example: '2026-04-08' })
  @Expose()
  date: string;

  @ApiProperty({ type: Number, example: 1200000 })
  @Expose()
  grossAmount: number;

  @ApiProperty({ type: Number, example: 1164000 })
  @Expose()
  netAmount: number;

  @ApiProperty({ type: Number, example: 0 })
  @Expose()
  refundAmount: number;
}
