import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsOptional,
  IsString,
  IsEnum,
  IsDateString,
  MaxLength,
} from 'class-validator';
import { Transform } from 'class-transformer';
import { PartnerFinancePeriod } from '@/partner-finance/enums/partner-finance-period.enum';
import { PartnerCommerceSourceType } from '@/partner-finance/enums/partner-commerce-source-type.enum';
import { PartnerTransactionType } from '@/partner-finance/enums/partner-transaction-type.enum';
import { PartnerTransactionStatus } from '@/partner-finance/enums/partner-transaction-status.enum';
import { PartnerSettlementStatus } from '@/partner-finance/enums/partner-settlement-status.enum';
import { PartnerPayoutStatus } from '@/partner-finance/enums/partner-payout-status.enum';

/**
 * Shared query parameters for finance summary, trend, and list endpoints.
 *
 * `period` defaults to `thirtyDays` when neither `startDate` nor `endDate` is provided.
 */
export class PartnerFinanceQueryDto {
  @ApiPropertyOptional({
    type: String,
    description: 'Free-text search (max 120 chars)',
    example: 'BK-240408',
  })
  @IsOptional()
  @IsString()
  @MaxLength(120)
  @Transform(({ value }) => value?.trim())
  search?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Inclusive start date (ISO 8601)',
    example: '2026-04-01',
  })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Inclusive end date (ISO 8601)',
    example: '2026-04-30',
  })
  @IsOptional()
  @IsDateString()
  endDate?: string;

  @ApiPropertyOptional({
    enum: PartnerFinancePeriod,
    enumName: 'PartnerFinancePeriod',
    default: PartnerFinancePeriod.THIRTY_DAYS,
    description:
      'Relative time window (ignored when both startDate and endDate are set)',
  })
  @IsOptional()
  @IsEnum(PartnerFinancePeriod)
  period?: PartnerFinancePeriod;

  @ApiPropertyOptional({
    enum: PartnerCommerceSourceType,
    enumName: 'PartnerCommerceSourceType',
    description: 'Filter by commerce source',
  })
  @IsOptional()
  @IsEnum(PartnerCommerceSourceType)
  sourceType?: PartnerCommerceSourceType;

  @ApiPropertyOptional({
    enum: PartnerTransactionType,
    enumName: 'PartnerTransactionType',
    description: 'Filter by transaction type',
  })
  @IsOptional()
  @IsEnum(PartnerTransactionType)
  transactionType?: PartnerTransactionType;

  @ApiPropertyOptional({
    enum: PartnerTransactionStatus,
    enumName: 'PartnerTransactionStatus',
    description: 'Filter by transaction status',
  })
  @IsOptional()
  @IsEnum(PartnerTransactionStatus)
  transactionStatus?: PartnerTransactionStatus;

  @ApiPropertyOptional({
    enum: PartnerSettlementStatus,
    enumName: 'PartnerSettlementStatus',
    description: 'Filter by settlement status',
  })
  @IsOptional()
  @IsEnum(PartnerSettlementStatus)
  settlementStatus?: PartnerSettlementStatus;

  @ApiPropertyOptional({
    enum: PartnerPayoutStatus,
    enumName: 'PartnerPayoutStatus',
    description: 'Filter by payout status',
  })
  @IsOptional()
  @IsEnum(PartnerPayoutStatus)
  payoutStatus?: PartnerPayoutStatus;

  @ApiPropertyOptional({
    type: String,
    description: 'ISO 4217 currency code',
    example: 'VND',
  })
  @IsOptional()
  @IsString()
  @MaxLength(10)
  currency?: string;
}
