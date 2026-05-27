import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { PartnerPayoutStatus } from '@/partner-finance/enums/partner-payout-status.enum';

export class PartnerFinanceSummaryDto {
  @ApiProperty({ type: Number, example: 2700000 })
  @Expose()
  grossVolume: number;

  @ApiProperty({ type: Number, example: 950600 })
  @Expose()
  netSettled: number;

  @ApiProperty({ type: Number, example: 2619000 })
  @Expose()
  pendingPayout: number;

  @ApiProperty({ type: Number, example: 700000 })
  @Expose()
  refundExposure: number;

  @ApiProperty({ type: Number, example: 250600 })
  @Expose()
  availableBalance: number;

  @ApiProperty({ type: Number, example: 2619000 })
  @Expose()
  pendingBalance: number;

  @ApiProperty({ type: String, example: 'VND' })
  @Expose()
  currency: string;

  @ApiPropertyOptional({
    type: String,
    nullable: true,
    example: '2026-04-10T03:00:00.000Z',
  })
  @Expose()
  nextPayoutAt!: string | null;

  @ApiPropertyOptional({
    type: String,
    nullable: true,
    example: 'Vietcombank ending 1122',
  })
  @Expose()
  payoutMethod!: string | null;

  @ApiPropertyOptional({
    enum: PartnerPayoutStatus,
    enumName: 'PartnerPayoutStatus',
    nullable: true,
    example: PartnerPayoutStatus.IN_PAYOUT,
  })
  @Expose()
  payoutStatus!: PartnerPayoutStatus | null;
}
