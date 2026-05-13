import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { PartnerCommerceSourceType } from '@/partner-finance/enums/partner-commerce-source-type.enum';
import { PartnerPayoutStatus } from '@/partner-finance/enums/partner-payout-status.enum';
import { PartnerRefundCaseStatus } from '@/partner-finance/enums/partner-refund-case-status.enum';
import { PartnerRefundCaseType } from '@/partner-finance/enums/partner-refund-case-type.enum';
import { PartnerSettlementStatus } from '@/partner-finance/enums/partner-settlement-status.enum';
import { PartnerTransactionStatus } from '@/partner-finance/enums/partner-transaction-status.enum';
import { PartnerTransactionType } from '@/partner-finance/enums/partner-transaction-type.enum';
import {
  AdminFinanceExportStatus,
  AdminFinanceExportType,
  AdminFinanceProvider,
  AdminFinanceReconciliationStatus,
  AdminFinanceReconciliationType,
  AdminFinanceRiskTone,
} from './admin-finance.enums';

export class AdminFinancePageMetaDto {
  @ApiProperty({ type: Number })
  total: number;

  @ApiProperty({ type: Number })
  page: number;

  @ApiProperty({ type: Number })
  limit: number;

  @ApiProperty({ type: Number })
  totalPages: number;

  static create(
    total: number,
    page: number,
    limit: number,
  ): AdminFinancePageMetaDto {
    const dto = new AdminFinancePageMetaDto();
    dto.total = total;
    dto.page = page;
    dto.limit = limit;
    dto.totalPages = Math.ceil(total / limit);
    return dto;
  }
}

export class AdminFinanceOverviewDto {
  @ApiProperty({ type: Number })
  grossVolume: number;

  @ApiProperty({ type: Number })
  netRevenue: number;

  @ApiProperty({ type: Number })
  platformFeeRevenue: number;

  @ApiProperty({ type: Number })
  refundExposure: number;

  @ApiProperty({ type: Number })
  failedPaymentAmount: number;

  @ApiProperty({ type: Number })
  pendingPayoutAmount: number;

  @ApiProperty({ type: Number })
  heldPayoutAmount: number;

  @ApiProperty({ type: Number })
  unreconciledAmount: number;

  @ApiProperty({ type: String, example: 'VND' })
  currency: string;
}

export class AdminFinanceTrendPointDto {
  @ApiProperty({ type: String, example: '2026-05-12' })
  date: string;

  @ApiProperty({ type: Number })
  grossAmount: number;

  @ApiProperty({ type: Number })
  netAmount: number;

  @ApiProperty({ type: Number })
  refundAmount: number;

  @ApiProperty({ type: Number })
  payoutAmount: number;
}

export class AdminFinanceAlertDto {
  @ApiProperty({ type: String })
  id: string;

  @ApiProperty({ type: String })
  title: string;

  @ApiProperty({ type: String })
  description: string;

  @ApiProperty({ enum: AdminFinanceRiskTone, enumName: 'AdminFinanceRiskTone' })
  tone: AdminFinanceRiskTone;

  @ApiProperty({ type: String })
  createdAt: string;
}

export class AdminFinanceNoteDto {
  @ApiProperty({ type: String })
  id: string;

  @ApiProperty({ type: String })
  content: string;

  @ApiProperty({ type: String })
  createdBy: string;

  @ApiProperty({ type: String })
  createdAt: string;
}

export class AdminFinanceProviderEventDto {
  @ApiProperty({ type: String })
  id: string;

  @ApiProperty({ type: String })
  eventType: string;

  @ApiProperty({ enum: AdminFinanceProvider, enumName: 'AdminFinanceProvider' })
  provider: AdminFinanceProvider;

  @ApiProperty({ type: String })
  occurredAt: string;

  @ApiProperty({ type: String })
  detail: string;

  @ApiProperty({ type: String })
  rawPayload: string;
}

export class AdminFinanceAuditEventDto {
  @ApiProperty({ type: String })
  id: string;

  @ApiProperty({ type: String })
  label: string;

  @ApiProperty({ type: String })
  detail: string;

  @ApiProperty({ type: String })
  performedBy: string;

  @ApiProperty({ type: String })
  occurredAt: string;

  @ApiProperty({ type: Boolean })
  isError: boolean;
}

export class AdminFinanceTransactionRecordDto {
  @ApiProperty({ type: String })
  id: string;

  @ApiProperty({ type: String })
  createdAt: string;

  @ApiProperty({ type: String })
  reference: string;

  @ApiProperty({ type: String })
  partnerName: string;

  @ApiProperty({ type: String })
  customerName: string;

  @ApiProperty({
    enum: PartnerCommerceSourceType,
    enumName: 'PartnerCommerceSourceType',
  })
  sourceType: PartnerCommerceSourceType;

  @ApiProperty({
    enum: PartnerTransactionType,
    enumName: 'PartnerTransactionType',
  })
  type: PartnerTransactionType;

  @ApiProperty({ type: Number })
  grossAmount: number;

  @ApiProperty({ type: Number })
  feeAmount: number;

  @ApiProperty({ type: Number })
  netAmount: number;

  @ApiProperty({ type: String })
  currency: string;

  @ApiProperty({
    enum: PartnerTransactionStatus,
    enumName: 'PartnerTransactionStatus',
  })
  transactionStatus: PartnerTransactionStatus;

  @ApiProperty({
    enum: PartnerSettlementStatus,
    enumName: 'PartnerSettlementStatus',
  })
  settlementStatus: PartnerSettlementStatus;

  @ApiProperty({ enum: PartnerPayoutStatus, enumName: 'PartnerPayoutStatus' })
  payoutStatus: PartnerPayoutStatus;

  @ApiProperty({ enum: AdminFinanceProvider, enumName: 'AdminFinanceProvider' })
  provider: AdminFinanceProvider;

  @ApiProperty({ type: Boolean })
  isFlagged: boolean;

  @ApiProperty({ type: Number })
  notesCount: number;

  @ApiPropertyOptional({ type: String, nullable: true })
  payoutId: string | null;
}

export class AdminFinanceTransactionPageDto {
  @ApiProperty({ type: [AdminFinanceTransactionRecordDto] })
  @Type(() => AdminFinanceTransactionRecordDto)
  data: AdminFinanceTransactionRecordDto[];

  @ApiProperty({ type: AdminFinancePageMetaDto })
  @Type(() => AdminFinancePageMetaDto)
  meta: AdminFinancePageMetaDto;
}

export class AdminFinanceTransactionDetailDto {
  @ApiProperty({ type: AdminFinanceTransactionRecordDto })
  @Type(() => AdminFinanceTransactionRecordDto)
  record: AdminFinanceTransactionRecordDto;

  @ApiProperty({ type: [AdminFinanceProviderEventDto] })
  @Type(() => AdminFinanceProviderEventDto)
  providerEvents: AdminFinanceProviderEventDto[];

  @ApiProperty({ type: [AdminFinanceAuditEventDto] })
  @Type(() => AdminFinanceAuditEventDto)
  auditTrail: AdminFinanceAuditEventDto[];

  @ApiProperty({ type: [AdminFinanceNoteDto] })
  @Type(() => AdminFinanceNoteDto)
  notes: AdminFinanceNoteDto[];

  @ApiProperty({ type: () => [AdminFinanceRefundCaseRecordDto] })
  @Type(() => AdminFinanceRefundCaseRecordDto)
  relatedRefundCases: AdminFinanceRefundCaseRecordDto[];
}

export class AdminFinancePayoutRecordDto {
  @ApiProperty({ type: String })
  id: string;

  @ApiProperty({ type: String })
  scheduledDate: string;

  @ApiProperty({ type: String })
  partnerName: string;

  @ApiProperty({ type: String })
  periodLabel: string;

  @ApiProperty({ type: Number })
  includedVolume: number;

  @ApiProperty({ type: Number })
  feesAndAdjustments: number;

  @ApiProperty({ type: Number })
  netPayout: number;

  @ApiProperty({ type: String })
  currency: string;

  @ApiProperty({ type: String })
  method: string;

  @ApiProperty({ enum: PartnerPayoutStatus, enumName: 'PartnerPayoutStatus' })
  status: PartnerPayoutStatus;

  @ApiProperty({ type: Number })
  attemptCount: number;

  @ApiProperty({ type: Number })
  notesCount: number;

  @ApiPropertyOptional({ type: String, nullable: true })
  failureReason: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  holdReason: string | null;
}

export class AdminFinancePayoutAttemptDto {
  @ApiProperty({ type: Number })
  attemptNumber: number;

  @ApiProperty({ type: String })
  attemptedAt: string;

  @ApiProperty({ type: String })
  status: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  failureReason: string | null;
}

export class AdminFinancePayoutPageDto {
  @ApiProperty({ type: [AdminFinancePayoutRecordDto] })
  @Type(() => AdminFinancePayoutRecordDto)
  data: AdminFinancePayoutRecordDto[];

  @ApiProperty({ type: AdminFinancePageMetaDto })
  @Type(() => AdminFinancePageMetaDto)
  meta: AdminFinancePageMetaDto;
}

export class AdminFinancePayoutDetailDto {
  @ApiProperty({ type: AdminFinancePayoutRecordDto })
  @Type(() => AdminFinancePayoutRecordDto)
  record: AdminFinancePayoutRecordDto;

  @ApiProperty({ type: [AdminFinanceTransactionRecordDto] })
  @Type(() => AdminFinanceTransactionRecordDto)
  includedTransactions: AdminFinanceTransactionRecordDto[];

  @ApiProperty({ type: [AdminFinancePayoutAttemptDto] })
  @Type(() => AdminFinancePayoutAttemptDto)
  attempts: AdminFinancePayoutAttemptDto[];

  @ApiProperty({ type: String })
  maskedDestination: string;

  @ApiProperty({ type: [AdminFinanceAuditEventDto] })
  @Type(() => AdminFinanceAuditEventDto)
  auditTrail: AdminFinanceAuditEventDto[];

  @ApiProperty({ type: [AdminFinanceNoteDto] })
  @Type(() => AdminFinanceNoteDto)
  notes: AdminFinanceNoteDto[];
}

export class AdminFinanceRefundCaseRecordDto {
  @ApiProperty({ type: String })
  id: string;

  @ApiProperty({ type: String })
  requestedAt: string;

  @ApiProperty({ type: String })
  transactionId: string;

  @ApiProperty({ type: String })
  partnerName: string;

  @ApiProperty({ type: String })
  customerName: string;

  @ApiProperty({
    enum: PartnerRefundCaseType,
    enumName: 'PartnerRefundCaseType',
  })
  caseType: PartnerRefundCaseType;

  @ApiProperty({ type: Number })
  amount: number;

  @ApiProperty({ type: String })
  currency: string;

  @ApiProperty({ type: String })
  reason: string;

  @ApiProperty({ type: String })
  owner: string;

  @ApiProperty({
    enum: PartnerRefundCaseStatus,
    enumName: 'PartnerRefundCaseStatus',
  })
  status: PartnerRefundCaseStatus;

  @ApiProperty({ type: Number })
  slaHours: number;

  @ApiProperty({ type: Boolean })
  slaBreached: boolean;

  @ApiProperty({ enum: AdminFinanceRiskTone, enumName: 'AdminFinanceRiskTone' })
  riskTone: AdminFinanceRiskTone;
}

export class AdminFinanceRefundCasePageDto {
  @ApiProperty({ type: [AdminFinanceRefundCaseRecordDto] })
  @Type(() => AdminFinanceRefundCaseRecordDto)
  data: AdminFinanceRefundCaseRecordDto[];

  @ApiProperty({ type: AdminFinancePageMetaDto })
  @Type(() => AdminFinancePageMetaDto)
  meta: AdminFinancePageMetaDto;
}

export class AdminFinanceRefundCaseDetailDto {
  @ApiProperty({ type: AdminFinanceRefundCaseRecordDto })
  @Type(() => AdminFinanceRefundCaseRecordDto)
  record: AdminFinanceRefundCaseRecordDto;

  @ApiProperty({ type: String })
  customerRequest: string;

  @ApiProperty({ type: String })
  partnerResponse: string;

  @ApiProperty({ type: [String] })
  evidenceLinks: string[];

  @ApiProperty({ type: String })
  decisionNote: string;

  @ApiProperty({ type: [AdminFinanceAuditEventDto] })
  @Type(() => AdminFinanceAuditEventDto)
  auditTrail: AdminFinanceAuditEventDto[];

  @ApiProperty({ type: [AdminFinanceNoteDto] })
  @Type(() => AdminFinanceNoteDto)
  notes: AdminFinanceNoteDto[];
}

export class AdminFinanceReconciliationExceptionDto {
  @ApiProperty({ type: String })
  id: string;

  @ApiProperty({ type: String })
  detectedAt: string;

  @ApiProperty({ enum: AdminFinanceProvider, enumName: 'AdminFinanceProvider' })
  provider: AdminFinanceProvider;

  @ApiProperty({ type: String })
  providerEventId: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  relatedTransactionId: string | null;

  @ApiProperty({ type: Number })
  expectedAmount: number;

  @ApiProperty({ type: Number })
  providerAmount: number;

  @ApiProperty({ type: Number })
  difference: number;

  @ApiProperty({ type: String })
  currency: string;

  @ApiProperty({
    enum: AdminFinanceReconciliationType,
    enumName: 'AdminFinanceReconciliationType',
  })
  type: AdminFinanceReconciliationType;

  @ApiProperty({
    enum: AdminFinanceReconciliationStatus,
    enumName: 'AdminFinanceReconciliationStatus',
  })
  status: AdminFinanceReconciliationStatus;

  @ApiProperty({ type: String })
  owner: string;

  @ApiProperty({ type: String })
  summary: string;
}

export class AdminFinanceReconciliationPageDto {
  @ApiProperty({ type: [AdminFinanceReconciliationExceptionDto] })
  @Type(() => AdminFinanceReconciliationExceptionDto)
  data: AdminFinanceReconciliationExceptionDto[];

  @ApiProperty({ type: AdminFinancePageMetaDto })
  @Type(() => AdminFinancePageMetaDto)
  meta: AdminFinancePageMetaDto;
}

export class AdminFinanceReconciliationDetailDto {
  @ApiProperty({ type: AdminFinanceReconciliationExceptionDto })
  @Type(() => AdminFinanceReconciliationExceptionDto)
  exception: AdminFinanceReconciliationExceptionDto;

  @ApiProperty({ type: String })
  providerEventContext: string;

  @ApiProperty({ type: String })
  ledgerContext: string;

  @ApiProperty({ type: String })
  resolutionNotes: string;

  @ApiProperty({ type: [AdminFinanceAuditEventDto] })
  @Type(() => AdminFinanceAuditEventDto)
  auditTrail: AdminFinanceAuditEventDto[];

  @ApiProperty({ type: [AdminFinanceNoteDto] })
  @Type(() => AdminFinanceNoteDto)
  notes: AdminFinanceNoteDto[];
}

export class AdminFinancePartnerExposureDto {
  @ApiProperty({ type: String })
  partnerId: string;

  @ApiProperty({ type: String })
  partnerName: string;

  @ApiProperty({ type: Number })
  totalVolume: number;

  @ApiProperty({ type: Number })
  pendingPayouts: number;

  @ApiProperty({ type: Number })
  refundExposure: number;

  @ApiProperty({ type: Number })
  failedPayments: number;

  @ApiProperty({ type: Number })
  heldFunds: number;

  @ApiProperty({ type: String })
  currency: string;

  @ApiProperty({ enum: AdminFinanceRiskTone, enumName: 'AdminFinanceRiskTone' })
  riskTone: AdminFinanceRiskTone;
}

export class AdminFinanceExportJobDto {
  @ApiProperty({ type: String })
  id: string;

  @ApiProperty({ type: String })
  createdAt: string;

  @ApiProperty({
    enum: AdminFinanceExportType,
    enumName: 'AdminFinanceExportType',
  })
  type: AdminFinanceExportType;

  @ApiProperty({ type: String })
  requestedBy: string;

  @ApiProperty({
    enum: AdminFinanceExportStatus,
    enumName: 'AdminFinanceExportStatus',
  })
  status: AdminFinanceExportStatus;

  @ApiProperty({ type: Number })
  rowCount: number;

  @ApiPropertyOptional({ type: String, nullable: true })
  downloadUrl: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  expiresAt: string | null;
}
