import { ApiProperty } from '@nestjs/swagger';
import {
    IsEnum,
    IsString,
    IsNotEmpty,
    IsBoolean,
    IsUrl,
    IsDateString,
    MaxLength,
    ValidateNested,
    ValidateIf,
    IsOptional,
    Matches,
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


export class AuthorizationRequestDto {
    @ApiProperty({
        example: true,
        description: 'Whether the legal representative is the authorized user',
    })
    @IsBoolean()
    isAuthorizedUser: boolean;

    @ApiProperty({
        example: 'https://storage.example.com/auth_letter.pdf',
        description: 'URL to authorization letter document (required if isAuthorizedUser is false)',
        required: false,
    })
    @ValidateIf((o) => !o.isAuthorizedUser)
    @IsUrl()
    @IsNotEmpty()
    authLetterDocUrl: string | null;
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

    @ApiProperty({
        example: 'Giám đốc',
        description: 'Position in the company',
        required: false,
    })
    @IsString()
    @IsOptional()
    @MaxLength(50)
    position?: string;

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

    @ApiProperty({ type: AuthorizationRequestDto })
    @ValidateNested()
    @Type(() => AuthorizationRequestDto)
    authorization: AuthorizationRequestDto;
}
