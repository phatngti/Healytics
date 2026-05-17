import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { BusinessType } from '@/partners/enum/business-type.enum';
import {
  PartnerVerificationStatus,
} from '@/partners/enum/partner-verification-status.enum';
import { PartnerPriority } from './admin-partner-detail-response.dto';

/**
 * Admin-specific partner list item with priority
 * and account-active flag.
 */
export class AdminPartnerItemDto {
  @ApiProperty({ example: 'uuid-123' })
  @Expose()
  id: string;

  @ApiProperty({ example: '0123456789' })
  @Expose()
  taxCode: string;

  @ApiProperty({ example: 'Hanoi Spa Co., Ltd' })
  @Expose()
  legalName: string;

  @ApiProperty({ example: 'Hanoi Spa' })
  @Expose()
  brandName: string;

  @ApiProperty({ example: 'partner@example.com' })
  @Expose()
  email: string;

  @ApiProperty({
    enum: BusinessType,
    enumName: 'BusinessType',
    isArray: true,
    example: [BusinessType.SPA_BEAUTY],
  })
  @Expose()
  businessType: BusinessType[];

  @ApiProperty({
    enum: PartnerVerificationStatus,
    enumName: 'PartnerVerificationStatus',
    example: PartnerVerificationStatus.PENDING,
  })
  @Expose()
  verificationStatus: PartnerVerificationStatus;

  @ApiProperty({
    enum: PartnerPriority,
    enumName: 'PartnerPriority',
    example: PartnerPriority.NORMAL,
  })
  @Expose()
  priority: PartnerPriority;

  @ApiProperty({ example: '2024-01-15T10:30:00Z' })
  @Expose()
  createdAt: Date;

  @ApiPropertyOptional({
    example: '2024-01-20T12:00:00Z',
    nullable: true,
  })
  @Expose()
  verificationCompletedAt?: Date | null;

  @ApiProperty({
    example: true,
    description: 'Whether the linked account is active',
  })
  @Expose()
  isAccountActive: boolean;
}

/**
 * Paginated response for admin partner list.
 */
export class AdminPartnersResponseDto {
  @ApiProperty({ type: [AdminPartnerItemDto] })
  @Type(() => AdminPartnerItemDto)
  @Expose()
  data: AdminPartnerItemDto[];

  @ApiProperty({ example: 50 })
  @Expose()
  total: number;

  @ApiProperty({ example: 1 })
  @Expose()
  page: number;

  @ApiProperty({ example: 10 })
  @Expose()
  limit: number;
}
