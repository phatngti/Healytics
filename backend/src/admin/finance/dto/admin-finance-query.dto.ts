import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsBoolean,
  IsDateString,
  IsEnum,
  IsNumber,
  IsOptional,
  IsString,
  Max,
  Min,
} from 'class-validator';
import { PartnerCommerceSourceType } from '@/partner-finance/enums/partner-commerce-source-type.enum';
import { PartnerPayoutStatus } from '@/partner-finance/enums/partner-payout-status.enum';
import { PartnerRefundCaseStatus } from '@/partner-finance/enums/partner-refund-case-status.enum';
import { PartnerRefundCaseType } from '@/partner-finance/enums/partner-refund-case-type.enum';
import { PartnerSettlementStatus } from '@/partner-finance/enums/partner-settlement-status.enum';
import { PartnerTransactionStatus } from '@/partner-finance/enums/partner-transaction-status.enum';
import { PartnerTransactionType } from '@/partner-finance/enums/partner-transaction-type.enum';
import {
  AdminFinancePeriod,
  AdminFinanceProvider,
  AdminFinanceReconciliationStatus,
} from './admin-finance.enums';

export class AdminFinanceQueryDto {
  @ApiPropertyOptional({ type: String })
  @IsOptional()
  @IsString()
  search?: string;

  @ApiPropertyOptional({
    enum: AdminFinancePeriod,
    enumName: 'AdminFinancePeriod',
  })
  @IsOptional()
  @IsEnum(AdminFinancePeriod)
  period?: AdminFinancePeriod;

  @ApiPropertyOptional({ type: String, format: 'date' })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiPropertyOptional({ type: String, format: 'date' })
  @IsOptional()
  @IsDateString()
  endDate?: string;

  @ApiPropertyOptional({ type: String, format: 'uuid' })
  @IsOptional()
  @IsString()
  partnerId?: string;

  @ApiPropertyOptional({ type: String, format: 'uuid' })
  @IsOptional()
  @IsString()
  customerId?: string;

  @ApiPropertyOptional({
    enum: PartnerCommerceSourceType,
    enumName: 'PartnerCommerceSourceType',
  })
  @IsOptional()
  @IsEnum(PartnerCommerceSourceType)
  sourceType?: PartnerCommerceSourceType;

  @ApiPropertyOptional({
    enum: PartnerTransactionType,
    enumName: 'PartnerTransactionType',
  })
  @IsOptional()
  @IsEnum(PartnerTransactionType)
  transactionType?: PartnerTransactionType;

  @ApiPropertyOptional({
    enum: PartnerTransactionStatus,
    enumName: 'PartnerTransactionStatus',
  })
  @IsOptional()
  @IsEnum(PartnerTransactionStatus)
  transactionStatus?: PartnerTransactionStatus;

  @ApiPropertyOptional({
    enum: PartnerSettlementStatus,
    enumName: 'PartnerSettlementStatus',
  })
  @IsOptional()
  @IsEnum(PartnerSettlementStatus)
  settlementStatus?: PartnerSettlementStatus;

  @ApiPropertyOptional({
    enum: PartnerPayoutStatus,
    enumName: 'PartnerPayoutStatus',
  })
  @IsOptional()
  @IsEnum(PartnerPayoutStatus)
  payoutStatus?: PartnerPayoutStatus;

  @ApiPropertyOptional({
    enum: PartnerRefundCaseStatus,
    enumName: 'PartnerRefundCaseStatus',
  })
  @IsOptional()
  @IsEnum(PartnerRefundCaseStatus)
  refundCaseStatus?: PartnerRefundCaseStatus;

  @ApiPropertyOptional({
    enum: PartnerRefundCaseType,
    enumName: 'PartnerRefundCaseType',
  })
  @IsOptional()
  @IsEnum(PartnerRefundCaseType)
  refundCaseType?: PartnerRefundCaseType;

  @ApiPropertyOptional({
    enum: AdminFinanceReconciliationStatus,
    enumName: 'AdminFinanceReconciliationStatus',
  })
  @IsOptional()
  @IsEnum(AdminFinanceReconciliationStatus)
  reconciliationStatus?: AdminFinanceReconciliationStatus;

  @ApiPropertyOptional({
    enum: AdminFinanceProvider,
    enumName: 'AdminFinanceProvider',
  })
  @IsOptional()
  @IsEnum(AdminFinanceProvider)
  provider?: AdminFinanceProvider;

  @ApiPropertyOptional({ type: String, example: 'VND' })
  @IsOptional()
  @IsString()
  currency?: string;

  @ApiPropertyOptional({ type: Number })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  minAmount?: number;

  @ApiPropertyOptional({ type: Number })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  maxAmount?: number;

  @ApiPropertyOptional({ type: Boolean })
  @IsOptional()
  @Type(() => Boolean)
  @IsBoolean()
  onlyFlagged?: boolean;

  @ApiPropertyOptional({ type: Boolean })
  @IsOptional()
  @Type(() => Boolean)
  @IsBoolean()
  onlySlaBreached?: boolean;

  @ApiPropertyOptional({ type: Number, minimum: 1, default: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(1)
  page?: number = 1;

  @ApiPropertyOptional({ type: Number, minimum: 1, maximum: 100, default: 50 })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(1)
  @Max(100)
  limit?: number = 50;
}
