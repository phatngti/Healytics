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
import { DocumentFileType, DocumentFileTypes, DocumentTypes, DocumentTypeValue } from '@/partners/entities/partner-document.entity';


export class PartnerDocumentVerificationDto {
    @ApiProperty({
        example: 'image',
        description: 'File type of document',
    })
    @IsEnum(DocumentFileTypes)
    fileType: DocumentFileType;

    @ApiProperty({
        example: 'BUSINESS_LICENSE',
        description: 'Type of document',
    })
    @IsEnum(DocumentTypes)
    type: DocumentTypeValue;

    @ApiProperty({
        example: 'business_license.pdf',
        description: 'Document key (R2/S3 path)',
    })
    @IsString()
    @IsNotEmpty()
    documentKey: string;

    @ApiProperty({
        example: ['https://storage.example.com/business_license.pdf'],
        description: 'Array of URLs to document files',
        type: [String],
    })
    @IsArray()
    @IsUrl({}, { each: true })
    urls: string[];
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


    @ApiProperty({ type: [PartnerDocumentVerificationDto] })
    @ValidateNested({ each: true })
    @Type(() => PartnerDocumentVerificationDto)
    documents: PartnerDocumentVerificationDto[];
}
