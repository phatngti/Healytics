import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { PartnerRefundCaseType } from '@/partner-finance/enums/partner-refund-case-type.enum';
import { PartnerRefundCaseStatus } from '@/partner-finance/enums/partner-refund-case-status.enum';
import { PartnerRefundCase } from '@/common/entities/partner-refund-case.entity';

export class PartnerRefundCaseRecordDto {
  @ApiProperty({ type: String })
  @Expose()
  id: string;

  @ApiProperty({ type: String })
  @Expose()
  transactionId: string;

  @ApiProperty({ enum: PartnerRefundCaseType, enumName: 'PartnerRefundCaseType' })
  @Expose()
  caseType: PartnerRefundCaseType;

  @ApiProperty({ type: String, example: '2026-04-06T10:00:00.000Z' })
  @Expose()
  requestedAt: string;

  @ApiProperty({ type: Number, example: 350000 })
  @Expose()
  amount: number;

  @ApiProperty({ type: String, example: 'VND' })
  @Expose()
  currency: string;

  @ApiProperty({ type: String, example: 'Service not as described' })
  @Expose()
  reason: string;

  @ApiProperty({ type: String, example: 'Customer Support' })
  @Expose()
  owner: string;

  @ApiProperty({ enum: PartnerRefundCaseStatus, enumName: 'PartnerRefundCaseStatus' })
  @Expose()
  status: PartnerRefundCaseStatus;

  @ApiProperty({ type: Number, example: 48, description: 'Remaining SLA hours (0 for resolved cases)' })
  @Expose()
  slaHours: number;

  static fromEntity(entity: PartnerRefundCase): PartnerRefundCaseRecordDto {
    const dto = new PartnerRefundCaseRecordDto();
    dto.id = entity.id;
    dto.transactionId = entity.transactionId;
    dto.caseType = entity.caseType;
    dto.requestedAt = entity.requestedAt?.toISOString();
    dto.amount = Number(entity.amount);
    dto.currency = entity.currency;
    dto.reason = entity.reason ?? '';
    dto.owner = entity.owner;
    dto.status = entity.status;
    dto.slaHours = PartnerRefundCaseRecordDto.calculateSlaHours(entity);
    return dto;
  }

  static fromEntities(entities: PartnerRefundCase[]): PartnerRefundCaseRecordDto[] {
    return entities.map((e) => PartnerRefundCaseRecordDto.fromEntity(e));
  }

  private static calculateSlaHours(entity: PartnerRefundCase): number {
    // Terminal statuses always return 0
    if (
      entity.status === PartnerRefundCaseStatus.APPROVED ||
      entity.status === PartnerRefundCaseStatus.REJECTED
    ) {
      return 0;
    }
    if (!entity.slaDueAt) return 0;
    const remaining = (entity.slaDueAt.getTime() - Date.now()) / (1000 * 60 * 60);
    return Math.max(0, Math.round(remaining));
  }
}
