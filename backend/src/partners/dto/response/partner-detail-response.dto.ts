import { ApiProperty } from '@nestjs/swagger';
import { BusinessType } from '@/partners/enum/business-type.enum';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';

class AccountInfoDto {
    @ApiProperty({ example: 'uuid' })
    id: string;

    @ApiProperty({ example: 'partner@example.com' })
    email: string;

    @ApiProperty({ example: true })
    isActive: boolean;
}

class AddressDetailDto {
    @ApiProperty({ example: 'uuid', nullable: true })
    provinceId: string | null;

    @ApiProperty({ example: 'Hà Nội' })
    province: string;

    @ApiProperty({ example: 'uuid', nullable: true })
    districtId: string | null;

    @ApiProperty({ example: 'Hoàn Kiếm' })
    district: string;

    @ApiProperty({ example: 'uuid', nullable: true })
    wardId: string | null;

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

    @ApiProperty({ example: 'https://example.com/front.jpg', nullable: true })
    idFrontImgUrl: string | null;

    @ApiProperty({ example: 'https://example.com/back.jpg', nullable: true })
    idBackImgUrl: string | null;

    @ApiProperty({ example: true })
    isAuthorizedUser: boolean;

    @ApiProperty({ example: 'https://example.com/auth-letter.pdf', nullable: true })
    authLetterDocUrl: string | null;
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

    @ApiProperty({ enum: PartnerVerificationStatus, example: PartnerVerificationStatus.PENDING })
    verificationStatus: PartnerVerificationStatus;

    @ApiProperty({ example: null, nullable: true })
    verificationCompletedAt: Date | null;

    @ApiProperty({ example: '2024-01-15T10:30:00Z' })
    createdAt: Date;
}
