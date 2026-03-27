import { ApiProperty } from '@nestjs/swagger';
import { BusinessType } from '@/partners/enum/business-type.enum';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';

export class PartnerItemDto {
    @ApiProperty({ example: 'uuid' })
    id: string;

    @ApiProperty({ example: '0123456789' })
    taxCode: string;

    @ApiProperty({ example: 'Hanoi Spa' })
    brandName: string;

    @ApiProperty({ example: 'Hanoi Spa Co., Ltd' })
    legalName: string;

    @ApiProperty({ example: 'partner@example.com' })
    email: string;

    @ApiProperty({ enum: BusinessType, enumName: 'BusinessType', isArray: true, example: [BusinessType.SPA_BEAUTY] })
    businessType: BusinessType[];

    @ApiProperty({ enum: PartnerVerificationStatus, enumName: 'PartnerVerificationStatus', example: PartnerVerificationStatus.PENDING })
    verificationStatus: PartnerVerificationStatus;

    @ApiProperty({ example: '2024-01-15T10:30:00Z' })
    createdAt: Date;
}

export class PartnersResponseDto {
    @ApiProperty({ type: [PartnerItemDto] })
    data: PartnerItemDto[];

    @ApiProperty({ example: 50 })
    total: number;

    @ApiProperty({ example: 1 })
    page: number;

    @ApiProperty({ example: 10 })
    limit: number;
}
