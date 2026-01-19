import { ApiProperty } from '@nestjs/swagger';
import { BusinessType } from '@/partners/enum/business-type.enum';

class AddressDto {
    @ApiProperty({ example: 'Hà Nội' })
    province: string;

    @ApiProperty({ example: 'Hoàn Kiếm' })
    district: string;

    @ApiProperty({ example: 'Hàng Bạc' })
    ward: string;

    @ApiProperty({ example: '123 Le Loi Street' })
    streetAddress: string;
}

class LegalRepresentativeDto {
    @ApiProperty({ example: 'NGUYEN VAN A' })
    fullName: string;

    @ApiProperty({ example: 'Giám đốc' })
    position: string;

    @ApiProperty({ example: 'CITIZEN_ID' })
    idType: string;

    @ApiProperty({ example: '001234567890' })
    idNumber: string;
}

export class MyProfileResponseDto {
    @ApiProperty({ example: 'uuid' })
    id: string;

    @ApiProperty({ example: '0123456789' })
    taxCode: string;

    @ApiProperty({ example: 'CÔNG TY TNHH SPA HÀ NỘI' })
    legalName: string;

    @ApiProperty({ example: 'Hanoi Spa' })
    brandName: string;

    @ApiProperty({ enum: BusinessType, example: BusinessType.SPA_BEAUTY })
    businessType: BusinessType;

    @ApiProperty({ type: AddressDto })
    address: AddressDto;

    @ApiProperty({ type: LegalRepresentativeDto })
    legalRepresentative: LegalRepresentativeDto;

    @ApiProperty({ example: false })
    isVerified: boolean;

    @ApiProperty({ example: null, nullable: true })
    verificationCompletedAt: Date | null;

    @ApiProperty({ example: '2024-01-15T10:30:00Z' })
    createdAt: Date;
}
