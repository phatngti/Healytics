import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum, IsString, IsInt, Min } from 'class-validator';
import { Type } from 'class-transformer';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';

export class GetPartnersQueryDto {
  @ApiPropertyOptional({
    example: 1,
    description: 'Page number',
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
    enum: PartnerVerificationStatus,
    example: PartnerVerificationStatus.PENDING,
    description:
      'Filter by verification status (PENDING, REQUIRED_RESUBMIT, APPROVED, REJECTED)',
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
}
