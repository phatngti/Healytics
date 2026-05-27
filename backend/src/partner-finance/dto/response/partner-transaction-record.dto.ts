import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { PartnerTransactionType } from '@/partner-finance/enums/partner-transaction-type.enum';
import { PartnerCommerceSourceType } from '@/partner-finance/enums/partner-commerce-source-type.enum';
import { PartnerTransactionStatus } from '@/partner-finance/enums/partner-transaction-status.enum';
import { PartnerSettlementStatus } from '@/partner-finance/enums/partner-settlement-status.enum';
import { PartnerPayoutStatus } from '@/partner-finance/enums/partner-payout-status.enum';
import { PartnerTransactionTimelineEventDto } from './partner-transaction-timeline-event.dto';
import { PartnerLedgerTransaction } from '@/common/entities/partner-ledger-transaction.entity';

export class PartnerTransactionRecordDto {
  @ApiProperty({ type: String })
  @Expose()
  id: string;

  @ApiProperty({ type: String, example: '2026-04-08T02:15:00.000Z' })
  @Expose()
  createdAt: string;

  @ApiProperty({
    enum: PartnerTransactionType,
    enumName: 'PartnerTransactionType',
  })
  @Expose()
  type: PartnerTransactionType;

  @ApiProperty({
    enum: PartnerCommerceSourceType,
    enumName: 'PartnerCommerceSourceType',
  })
  @Expose()
  sourceType: PartnerCommerceSourceType;

  @ApiProperty({ type: String, example: 'BK-240408-001' })
  @Expose()
  reference: string;

  @ApiProperty({ type: String, example: 'Nguyen Minh Anh' })
  @Expose()
  customerName: string;

  @ApiProperty({ type: Number, example: 1200000 })
  @Expose()
  grossAmount: number;

  @ApiProperty({ type: Number, example: 36000 })
  @Expose()
  feeAmount: number;

  @ApiProperty({ type: Number, example: 1164000 })
  @Expose()
  netAmount: number;

  @ApiProperty({ type: String, example: 'VND' })
  @Expose()
  currency: string;

  @ApiProperty({
    enum: PartnerTransactionStatus,
    enumName: 'PartnerTransactionStatus',
  })
  @Expose()
  status: PartnerTransactionStatus;

  @ApiProperty({
    enum: PartnerSettlementStatus,
    enumName: 'PartnerSettlementStatus',
  })
  @Expose()
  settlementStatus: PartnerSettlementStatus;

  @ApiProperty({ enum: PartnerPayoutStatus, enumName: 'PartnerPayoutStatus' })
  @Expose()
  payoutStatus: PartnerPayoutStatus;

  @ApiProperty({ type: String, example: 'MoMo Wallet' })
  @Expose()
  paymentMethod: string;

  @ApiProperty({ type: String, example: 'Dermatology consultation package' })
  @Expose()
  sourceTitle: string;

  @ApiProperty({ type: String, example: 'Confirmed service booking' })
  @Expose()
  sourceSubtitle: string;

  @ApiProperty({ type: [PartnerTransactionTimelineEventDto] })
  @Type(() => PartnerTransactionTimelineEventDto)
  @Expose()
  timeline: PartnerTransactionTimelineEventDto[];

  @ApiProperty({ type: Boolean, example: false })
  @Expose()
  flaggedForReview: boolean;

  @ApiPropertyOptional({ type: String, nullable: true })
  @Expose()
  notes!: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  @Expose()
  payoutId!: string | null;

  static fromEntity(
    entity: PartnerLedgerTransaction,
  ): PartnerTransactionRecordDto {
    const dto = new PartnerTransactionRecordDto();
    dto.id = entity.id;
    dto.createdAt = entity.createdAt?.toISOString();
    dto.type = entity.type;
    dto.sourceType = entity.sourceType;
    dto.reference = entity.reference;
    dto.customerName = entity.customerNameSnapshot;
    dto.grossAmount = Number(entity.grossAmount);
    dto.feeAmount = Number(entity.feeAmount);
    dto.netAmount = Number(entity.grossAmount) - Number(entity.feeAmount);
    dto.currency = entity.currency;
    dto.status = entity.status;
    dto.settlementStatus = entity.settlementStatus;
    dto.payoutStatus = entity.payoutStatus;
    dto.paymentMethod = entity.paymentMethodLabel ?? '';
    dto.sourceTitle = entity.sourceTitleSnapshot ?? '';
    dto.sourceSubtitle = entity.sourceSubtitleSnapshot ?? '';
    dto.timeline = (entity.timelineEvents ?? []).map((e) => ({
      title: e.title,
      description: e.description ?? '',
      occurredAt: e.occurredAt?.toISOString(),
    }));
    dto.flaggedForReview = entity.flaggedForReview;
    dto.notes = entity.notes ?? null;
    dto.payoutId = entity.payoutId ?? null;
    return dto;
  }

  static fromEntities(
    entities: PartnerLedgerTransaction[],
  ): PartnerTransactionRecordDto[] {
    return entities.map((e) => PartnerTransactionRecordDto.fromEntity(e));
  }
}
