import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsArray,
  IsEnum,
  IsNotEmpty,
  IsOptional,
  IsString,
} from 'class-validator';
import { BusinessType } from '@/partners/enum/business-type.enum';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';

export class SeedPartnerDto {
  @ApiPropertyOptional({ type: String, description: 'Unique lookup key' })
  @IsOptional()
  @IsString()
  key?: string;

  @ApiPropertyOptional({ type: String, example: 'partner@test.healytics.vn' })
  @IsOptional()
  @IsString()
  email?: string;

  @ApiPropertyOptional({ type: String, example: 'Password123!' })
  @IsOptional()
  @IsString()
  password?: string;

  @ApiPropertyOptional({ type: String, example: 'TAX-12345' })
  @IsOptional()
  @IsString()
  taxCode?: string;

  @ApiPropertyOptional({ type: String, example: 'Healytics Spa LLC' })
  @IsOptional()
  @IsString()
  legalName?: string;

  @ApiProperty({ type: String, example: 'Healytics Spa' })
  @IsString()
  @IsNotEmpty()
  brandName: string;

  @ApiPropertyOptional({
    type: Array<BusinessType>,
    description: 'Business type categories',
  })
  @IsOptional()
  @IsArray()
  @IsEnum(BusinessType, { each: true })
  businessTypes?: BusinessType[];

  @ApiPropertyOptional({
    type: String,
    example: 'District 1, Ho Chi Minh City',
  })
  @IsOptional()
  @IsString()
  streetAddress?: string;

  @ApiPropertyOptional({ type: String, example: '0901234567' })
  @IsOptional()
  @IsString()
  phoneNumber?: string;

  @ApiPropertyOptional({
    enum: PartnerVerificationStatus,
    description: 'Verification status',
  })
  @IsOptional()
  @IsEnum(PartnerVerificationStatus)
  status?: PartnerVerificationStatus;
}
