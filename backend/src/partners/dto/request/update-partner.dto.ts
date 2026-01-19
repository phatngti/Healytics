import { ApiPropertyOptional } from '@nestjs/swagger';
import {
    IsOptional,
    IsString,
    MaxLength,
    IsPhoneNumber,
    IsUUID,
    ValidateNested,
    IsEnum
} from 'class-validator';
import { Type } from 'class-transformer';
import { IdType } from '../../enum/id-type.enum';

export class UpdateLegalRepresentativeDto {
    @ApiPropertyOptional({
        example: 'Nguyen Van A',
        description: 'Full name of legal representative',
    })
    @IsOptional()
    @IsString()
    @MaxLength(150)
    fullName?: string;

    @ApiPropertyOptional({
        example: 'CEO',
        description: 'Position/title of legal representative',
    })
    @IsOptional()
    @IsString()
    @MaxLength(100)
    position?: string;

    @ApiPropertyOptional({
        example: '+84987654321',
        description: 'Phone number of legal representative',
    })
    @IsOptional()
    @IsString()
    phoneNumber?: string;

    @ApiPropertyOptional({
        example: IdType.CITIZEN_ID,
        enum: IdType,
        description: 'Type of identification document',
    })
    @IsOptional()
    @IsEnum(IdType)
    idType?: IdType;

    @ApiPropertyOptional({
        example: '001234567890',
        description: 'ID number',
    })
    @IsOptional()
    @IsString()
    @MaxLength(20)
    idNumber?: string;

    @ApiPropertyOptional({
        example: '2020-01-15',
        description: 'ID issue date (YYYY-MM-DD)',
    })
    @IsOptional()
    @IsString()
    idIssueDate?: string;

    @ApiPropertyOptional({
        example: 'https://example.com/id-front.jpg',
        description: 'URL of ID card front image',
    })
    @IsOptional()
    @IsString()
    idFrontImgUrl?: string;

    @ApiPropertyOptional({
        example: 'https://example.com/id-back.jpg',
        description: 'URL of ID card back image',
    })
    @IsOptional()
    @IsString()
    idBackImgUrl?: string;

    @ApiPropertyOptional({
        example: false,
        description: 'Whether this person is an authorized user',
    })
    @IsOptional()
    isAuthorizedUser?: boolean;

    @ApiPropertyOptional({
        example: 'https://example.com/auth-letter.pdf',
        description: 'Authorization letter document URL',
    })
    @IsOptional()
    @IsString()
    authLetterDocUrl?: string;
}

export class UpdatePartnerDto {
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
}
