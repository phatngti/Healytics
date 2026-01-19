import { ApiProperty } from '@nestjs/swagger';
import { BusinessType } from '@/partners/enum/business-type.enum';

class AccountInfoDto {
    @ApiProperty({ example: 'uuid' })
    id: string;

    @ApiProperty({ example: 'partner@example.com' })
    email: string;

    @ApiProperty({ example: true })
    isActive: boolean;
}

class AddressDetailDto {
    @ApiProperty({ example: 'Hà Nội' })
    province: string;

    @ApiProperty({ example: 'Hoàn Kiếm' })
    district: string;

    @ApiProperty({ example: 'Hàng Bạc' })
    ward: string;

    @ApiProperty({ example: '123 Le Loi Street' })
    streetAddress: string;
}

class LegalRepDetailDto {
    @ApiProperty({ example: 'NGUYEN VAN A' })
    fullName: string;

    @ApiProperty({ example: 'Giám đốc' })
    position: string;

    @ApiProperty({ example: 'CITIZEN_ID' })
    idType: string;

    @ApiProperty({ example: '001234567890' })
    idNumber: string;

    @ApiProperty({ example: '2020-01-01' })
    idIssueDate: Date;

    @ApiProperty({ example: true })
    isAuthorizedUser: boolean;
}

export class PartnerDetailResponseDto {
    @ApiProperty({ type: AccountInfoDto })
    account: AccountInfoDto;

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

    @ApiProperty({ type: AddressDetailDto })
    address: AddressDetailDto;

    @ApiProperty({ type: LegalRepDetailDto })
    legalRepresentative: LegalRepDetailDto;

    @ApiProperty({ example: false })
    isVerified: boolean;

    @ApiProperty({ example: null, nullable: true })
    verificationCompletedAt: Date | null;

    @ApiProperty({ example: '2024-01-15T10:30:00Z' })
    createdAt: Date;
}
