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

    // Added to match Admin requirement if needed, or we will adhere strictly to MyProfile structure first.
    // MyProfile's LegalRepDto only had these 4 fields in the previous view.
    // Checking previous view: yes only 4 fields.
    // Wait, Admin view had MORE fields (images, auth letter, etc).
    // The user said "same format". If I reduce Admin information, is that okay?
    // "result of get partner detail ... same to get profile"
    // If Partner Profile hides images, Admin might still need them.
    // But `MyProfileResponseDto` uses `Partner` entity relations.
    // Let's check `PartnersService.getMyProfile` mapping for LegalRep.
    // It maps: fullName, position, idType, idNumber.
    // It DOES NOT map images or auth letter.
    // If I make them the same, Admin loses access to ID images? That sounds bad for an Admin Detail view that is used for REVIEW.
    // Maybe the user means the "structure" (address object vs string, doc status) rather than removing fields.
    // I will export them but I might need to EXTEND them for Admin if fields are missing.
    // Actually, looking at `PartnerDetailResponseDto` in `partners/dto/response/partner-detail-response.dto.ts` (Viewed in step 7, lines 607+), there is a `PartnerDetailResponseDto`.
    // The user specifically said "get profile of partner service" which is `getMyProfile`.
    // I should check if `getMyProfile` really excludes images.
    // Step 7, line 297:
    // legalRepresentative: { fullName, position, idType, idNumber } -> YES, excludes images.
    // If I make Admin use this, Admin cannot review images.
    // Use `PartnerDetailResponseDto` as reference? No, user said "get profile".
    // I will assume user wants the *structure* (nested address, calculated doc status) but surely assumes Admin sees all info.
    // I will export these DTOs. I will verify if I should add images to `LegalRepresentativeDto`.
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
