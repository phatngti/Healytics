import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
    IsEnum,
    IsString,
    IsNotEmpty,
    IsUrl,
    IsDateString,
    MaxLength,
    ValidateNested,
    IsOptional,
    Matches,
    IsArray,
} from 'class-validator';
import { Type } from 'class-transformer';
import { IdType } from '@/partners/enum/id-type.enum';

export class IdImagesRequestDto {
    @ApiProperty({
        example: 'https://storage.example.com/id_front.jpg',
        description: 'URL to front image of ID document',
    })
    @IsUrl()
    @IsNotEmpty()
    frontImgUrl: string;

    @ApiProperty({
        example: 'https://storage.example.com/id_back.jpg',
        description: 'URL to back image of ID document',
    })
    @IsUrl()
    @IsNotEmpty()
    backImgUrl: string;
}

export class PartnerDocumentVerificationDto {
    @ApiPropertyOptional({
        example: 'https://storage.example.com/business_license.pdf',
        description: 'URL to business license document',
    })
    @IsOptional()
    @IsUrl()
    businessLicenseUrl?: string;

    @ApiPropertyOptional({
        example: 'https://storage.example.com/authorization_letter.pdf',
        description: 'URL to authorization letter document',
    })
    @IsOptional()
    @IsUrl()
    authorizationLetterUrl?: string;

    @ApiPropertyOptional({
        example: 'https://storage.example.com/tax_certificate.pdf',
        description: 'URL to tax certificate document',
    })
    @IsOptional()
    @IsUrl()
    taxCertificateUrl?: string;

    @ApiPropertyOptional({
        example: ['https://storage.example.com/other_doc1.pdf'],
        description: 'Array of URLs to other supporting documents',
        type: [String],
    })
    @IsOptional()
    @IsArray()
    @IsUrl({}, { each: true })
    otherDocumentUrls?: string[];
}

export class LegalRepresentativeRequestDto {
    @ApiProperty({
        example: 'NGUYỄN VĂN A',
        description: 'Full name of legal representative',
    })
    @IsString()
    @IsNotEmpty()
    @MaxLength(100)
    fullName: string;

    @ApiPropertyOptional({
        example: 'Giám đốc',
        description: 'Position in the company',
    })
    @IsString()
    @IsOptional()
    @MaxLength(50)
    position?: string;

    @ApiPropertyOptional({
        example: '0901234567',
        description: 'Phone number of legal representative',
    })
    @IsString()
    @IsOptional()
    @Matches(/^(0|\+84)[3-9][0-9]{8}$/, {
        message: 'Phone number must be a valid Vietnamese phone number',
    })
    phoneNumber?: string;

    @ApiProperty({
        enum: IdType,
        example: IdType.CITIZEN_ID,
        description: 'Type of identification document',
    })
    @IsEnum(IdType)
    idType: IdType;

    @ApiProperty({
        example: '001234567890',
        description: 'ID number (9 or 12 digits for Vietnam)',
    })
    @IsString()
    @IsNotEmpty()
    @Matches(/^\d{9}$|^\d{12}$/, {
        message: 'ID number must be 9 or 12 digits',
    })
    idNumber: string;

    @ApiProperty({
        example: '2023-01-15',
        description: 'Date of ID issuance (ISO 8601 format)',
    })
    @IsNotEmpty()
    @IsDateString()
    idIssueDate: string;

    @ApiProperty({ type: IdImagesRequestDto })
    @ValidateNested()
    @Type(() => IdImagesRequestDto)
    images: IdImagesRequestDto;

    @ApiProperty({ type: PartnerDocumentVerificationDto })
    @ValidateNested()
    @Type(() => PartnerDocumentVerificationDto)
    documents: PartnerDocumentVerificationDto;
}
