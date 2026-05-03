import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { PartnerPayoutStatus } from '@/partner-finance/enums/partner-payout-status.enum';
import { PartnerPayout } from '@/common/entities/partner-payout.entity';

export class PartnerPayoutRecordDto {
  @ApiProperty({ type: String })
  @Expose()
  id: string;

  @ApiProperty({ type: String, example: 'Apr 01 – Apr 08' })
  @Expose()
  periodLabel: string;

  @ApiProperty({ type: Number, example: 5400000 })
  @Expose()
  includedVolume: number;

  @ApiProperty({ type: Number, example: 162000 })
  @Expose()
  feesAdjustments: number;

  @ApiProperty({ type: Number, example: 5238000 })
  @Expose()
  netPayout: number;

  @ApiProperty({ type: String, example: '2026-04-10T03:00:00.000Z' })
  @Expose()
  scheduledDate: string;

  @ApiProperty({ type: String, example: 'Vietcombank ending 1122' })
  @Expose()
  method: string;

  @ApiProperty({ enum: PartnerPayoutStatus, enumName: 'PartnerPayoutStatus' })
  @Expose()
  status: PartnerPayoutStatus;

  @ApiProperty({ type: String, example: 'VND' })
  @Expose()
  currency: string;

  @ApiProperty({ type: [String] })
  @Expose()
  includedTransactionIds: string[];

  static fromEntity(
    entity: PartnerPayout,
    transactionIds: string[] = [],
  ): PartnerPayoutRecordDto {
    const dto = new PartnerPayoutRecordDto();
    dto.id = entity.id;
    dto.periodLabel = PartnerPayoutRecordDto.formatPeriodLabel(
      entity.periodStart,
      entity.periodEnd,
    );
    dto.includedVolume = Number(entity.includedVolume);
    dto.feesAdjustments = Number(entity.feesAdjustments);
    dto.netPayout = Number(entity.netPayout);
    dto.scheduledDate = entity.scheduledDate?.toISOString();
    dto.method = entity.methodLabel;
    dto.status = entity.status;
    dto.currency = entity.currency;
    dto.includedTransactionIds = transactionIds;
    return dto;
  }

  private static formatPeriodLabel(start: Date, end: Date): string {
    const fmt = (d: Date) =>
      d.toLocaleDateString('en-US', { month: 'short', day: '2-digit' });
    return `${fmt(start)} – ${fmt(end)}`;
  }
}
