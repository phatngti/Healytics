import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum, IsString, IsInt, Min } from 'class-validator';
import { Type } from 'class-transformer';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';

/**
 * Scope for the admin partner manager tabs.
 * VERIFICATION_QUEUE: only reviewable statuses.
 * ALL_PROVIDERS: every status.
 */
export enum AdminPartnerScope {
  VERIFICATION_QUEUE = 'VERIFICATION_QUEUE',
  ALL_PROVIDERS = 'ALL_PROVIDERS',
}

/**
 * Sortable columns for the admin partner list.
 */
export enum AdminPartnerSortBy {
  CREATED_AT = 'createdAt',
  BRAND_NAME = 'brandName',
  LEGAL_NAME = 'legalName',
  VERIFICATION_STATUS = 'verificationStatus',
  PRIORITY = 'priority',
}

/**
 * Sort direction for the admin partner list.
 */
export enum AdminPartnerSortDirection {
  ASC = 'ASC',
  DESC = 'DESC',
}

/**
 * Admin-specific query DTO for partner list,
 * total, and stats endpoints.
 */
export class AdminPartnersQueryDto {
  @ApiPropertyOptional({
    example: 1,
    description: 'Page number (1-indexed)',
    default: 1,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number = 1;

  @ApiPropertyOptional({
    example: 10,
    description: 'Items per page',
    default: 10,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  limit?: number = 10;

  @ApiPropertyOptional({
    enum: AdminPartnerScope,
    enumName: 'AdminPartnerScope',
    example: AdminPartnerScope.VERIFICATION_QUEUE,
    description: 'Tab scope: VERIFICATION_QUEUE or ALL_PROVIDERS',
  })
  @IsOptional()
  @IsEnum(AdminPartnerScope)
  scope?: AdminPartnerScope;

  @ApiPropertyOptional({
    enum: PartnerVerificationStatus,
    enumName: 'PartnerVerificationStatus',
    example: PartnerVerificationStatus.PENDING,
    description: 'Explicit status filter',
  })
  @IsOptional()
  @IsEnum(PartnerVerificationStatus)
  verificationStatus?: PartnerVerificationStatus;

  @ApiPropertyOptional({
    example: 'spa',
    description: 'Search by tax code, brand name, legal name, or email',
  })
  @IsOptional()
  @IsString()
  search?: string;

  @ApiPropertyOptional({
    enum: AdminPartnerSortBy,
    enumName: 'AdminPartnerSortBy',
    example: AdminPartnerSortBy.CREATED_AT,
    description: 'Column to sort by',
  })
  @IsOptional()
  @IsEnum(AdminPartnerSortBy)
  sortBy?: AdminPartnerSortBy;

  @ApiPropertyOptional({
    enum: AdminPartnerSortDirection,
    enumName: 'AdminPartnerSortDirection',
    example: AdminPartnerSortDirection.DESC,
    description: 'Sort direction',
  })
  @IsOptional()
  @IsEnum(AdminPartnerSortDirection)
  sortDirection?: AdminPartnerSortDirection;
}
