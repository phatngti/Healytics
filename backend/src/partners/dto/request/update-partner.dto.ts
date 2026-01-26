import { ApiPropertyOptional } from '@nestjs/swagger';
import { PartialType } from '@nestjs/swagger';
import {
    IsOptional,
    IsString,
    MaxLength,
    IsUUID,
    ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { LegalRepresentativeRequestDto } from './legal-representative-request.dto';

import { DocumentType } from '@/partners/enum/document-type.enum';
import { BusinessType } from '@/partners/enum/business-type.enum';
import { IsEnum } from 'class-validator';

/**
 * Update DTO for legal representative - all fields optional
 * Derived from LegalRepresentativeRequestDto using PartialType
 */
export class UpdateLegalRepresentativeDto extends PartialType(LegalRepresentativeRequestDto) { }

export class DocumentUpdateDto {
    @ApiPropertyOptional({ enum: DocumentType })
    @IsOptional()
    @IsString()
    documentType: DocumentType;

    @ApiPropertyOptional()
    @IsOptional()
    @IsString()
    documentUrl: string;
}

export class UpdatePartnerDto {
    @ApiPropertyOptional({
        example: '0123456789',
        description: 'Tax code (updatable if rejected)',
    })
    @IsOptional()
    @IsString()
    @MaxLength(20)
    taxCode?: string;

    @ApiPropertyOptional({
        example: 'Abc Industry',
        description: 'Business Type',
        enum: BusinessType,
    })
    @IsOptional()
    @IsEnum(BusinessType)
    businessType?: BusinessType;

    @ApiPropertyOptional({
        example: 'ABC Health Services Ltd.',
        description: 'Legal name of the business',
    })
    @IsOptional()
    @IsString()
    @MaxLength(200)
    legalName?: string;

    @ApiPropertyOptional({
        example: 'Hanoi Spa & Wellness',
        description: 'Brand name of the business',
    })
    @IsOptional()
    @IsString()
    @MaxLength(150)
    brandName?: string;

    @ApiPropertyOptional({
        example: '+84987654321',
        description: 'Contact phone number',
    })
    @IsOptional()
    @IsString()
    phoneNumber?: string;

    @ApiPropertyOptional({
        example: 'uuid-of-province',
        description: 'Province ID (administrative division)',
    })
    @IsOptional()
    @IsUUID()
    provinceId?: string;

    @ApiPropertyOptional({
        example: 'uuid-of-district',
        description: 'District ID (administrative division)',
    })
    @IsOptional()
    @IsUUID()
    districtId?: string;

    @ApiPropertyOptional({
        example: 'uuid-of-ward',
        description: 'Ward ID (administrative division)',
    })
    @IsOptional()
    @IsUUID()
    wardId?: string;

    @ApiPropertyOptional({
        example: '123 Le Loi Street',
        description: 'Street address',
    })
    @IsOptional()
    @IsString()
    @MaxLength(300)
    streetAddress?: string;

    @ApiPropertyOptional({
        type: UpdateLegalRepresentativeDto,
        description: 'Legal representative information to update',
    })
    @IsOptional()
    @ValidateNested()
    @Type(() => UpdateLegalRepresentativeDto)
    legalRepresentative?: UpdateLegalRepresentativeDto;

    @ApiPropertyOptional({
        type: [DocumentUpdateDto],
        description: 'List of documents to update or upload',
    })
    @IsOptional()
    @ValidateNested({ each: true })
    @Type(() => DocumentUpdateDto)
    documents?: DocumentUpdateDto[];
}
