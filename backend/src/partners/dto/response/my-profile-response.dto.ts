import { ApiProperty } from '@nestjs/swagger';
import { BusinessType } from '@/partners/enum/business-type.enum';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { DocumentType } from '@/partners/enum/document-type.enum';

export class AddressDto {
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

export class LegalRepresentativeDto {
    @ApiProperty({ example: 'NGUYEN VAN A' })
    fullName: string;

    @ApiProperty({ example: 'Giám đốc' })
    position: string;

    @ApiProperty({ example: 'CITIZEN_ID' })
    idType: string;

    @ApiProperty({ example: '001234567890' })
    idNumber: string;


}

import { PartnerDocumentStatus } from '@/partners/enum/partner-document-status.enum';

export class PartnerDocumentDto {
    @ApiProperty({ example: 'uuid-123', nullable: true })
    id: string | null;

    @ApiProperty({ enum: DocumentType })
    documentType: DocumentType;

    @ApiProperty({ example: 'https://...', nullable: true })
    documentUrl: string | null;

    @ApiProperty({ example: 'documents/...', nullable: true })
    documentKey: string | null;

    @ApiProperty({ enum: PartnerDocumentStatus, example: PartnerDocumentStatus.PENDING })
    status: PartnerDocumentStatus;

    @ApiProperty({ example: true })
    isRequired: boolean;

    @ApiProperty({ example: 'Business License', nullable: true })
    description: string | null;

    @ApiProperty({ example: false })
    isReviewed: boolean;

    @ApiProperty({ example: true })
    isValid: boolean;

    @ApiProperty({ example: 'Image blurry', nullable: true })
    adminFeedback: string | null;

    @ApiProperty({ example: 'Verified details', nullable: true })
    verificationNotes: string | null;

    @ApiProperty({ example: '2024-01-20T10:00:00Z', nullable: true })
    uploadedAt: Date | null;
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

    @ApiProperty({ example: '0901234567', nullable: true })
    phoneNumber: string | null;

    @ApiProperty({ type: AddressDto })
    address: AddressDto;

    @ApiProperty({ type: LegalRepresentativeDto })
    legalRepresentative: LegalRepresentativeDto;

    @ApiProperty({ enum: PartnerVerificationStatus, example: PartnerVerificationStatus.PENDING })
    verificationStatus: PartnerVerificationStatus;

    @ApiProperty({
        example: { taxCode: 'Invalid format' },
        nullable: true,
        description: 'Field-level rejection details'
    })
    rejectionDetails: Record<string, string> | null;

    @ApiProperty({ type: [PartnerDocumentDto], description: 'List of documents with their status' })
    documents: PartnerDocumentDto[];

    @ApiProperty({ example: null, nullable: true })
    verificationCompletedAt: Date | null;

    @ApiProperty({ example: '2024-01-15T10:30:00Z' })
    createdAt: Date;
}
