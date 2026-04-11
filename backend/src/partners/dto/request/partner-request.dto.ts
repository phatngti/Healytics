import {
  IsArray,
  IsEnum,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUUID,
  MaxLength,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { BusinessType } from '../../enum/business-type.enum';

/**
 * DTO for Partner (Business Entity) information during registration.
 */
export class PartnerRequestDto {
  @ApiProperty({
    description: 'Tax code of the business (unique identifier)',
    example: '0123456789',
    maxLength: 20,
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  taxCode: string;

  @ApiProperty({
    description: 'Legal name of the business',
    example: 'ABC Healthcare Company Limited',
    maxLength: 200,
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(200)
  legalName: string;

  @ApiProperty({
    description: 'Brand name of the business',
    example: 'ABC Clinic',
    maxLength: 150,
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(150)
  brandName: string;

  @ApiProperty({
    description: 'Type of business',
    enum: BusinessType,
    enumName: 'BusinessType',
    isArray: true,
    type: 'array',
    example: [BusinessType.MASSAGE_THERAPY],
  })
  @IsEnum(BusinessType, { each: true })
  businessType: BusinessType[];

  @ApiProperty({
    description: 'UUID of the province (from Location tree)',
    example: '123e4567-e89b-12d3-a456-426614174000',
  })
  @IsUUID()
  provinceId: string;

  @ApiProperty({
    description: 'UUID of the district (from Location tree)',
    example: '123e4567-e89b-12d3-a456-426614174001',
  })
  @IsUUID()
  districtId: string;

  @ApiProperty({
    description: 'UUID of the ward (from Location tree)',
    example: '123e4567-e89b-12d3-a456-426614174002',
  })
  @IsUUID()
  wardId: string;

  @ApiProperty({
    description: 'Street address of the business',
    example: '123 Main Street',
    maxLength: 300,
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(300)
  streetAddress: string;

  @ApiPropertyOptional({
    description:
      'Clinic/business contact phone number. This is the public-facing ' +
      'phone shown on the clinic info screen — NOT the legal ' +
      "representative's personal phone.",
    example: '0901234567',
    maxLength: 20,
  })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  phoneNumber?: string;
}
