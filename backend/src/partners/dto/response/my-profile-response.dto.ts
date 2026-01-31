import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { BusinessType } from '@/partners/enum/business-type.enum';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';

// ============================================================================
// Verification Field DTOs
// ============================================================================

/**
 * Base verification field with value, displayValue and update requirements
 */
export class VerificationStringFieldDto {
    @ApiProperty({ example: 'XX-1234567-Y', description: 'The raw value' })
    value: string;

    @ApiProperty({ example: 'XX-1234567-Y', description: 'Human-readable display value' })
    displayValue: string;

    @ApiProperty({ example: false, description: 'Whether this field requires update' })
    requiresUpdate: boolean;

    @ApiPropertyOptional({ example: 'Tax code mismatch with tax document.', nullable: true })
    adminFeedback?: string | null;

    @ApiPropertyOptional({ example: true, nullable: true, description: 'Whether this field was verified by admin (from partner_review_log)' })
    isVerified?: boolean | null;
}

/**
 * Optional verification field (value can be null)
 */
export class VerificationOptionalStringFieldDto {
    @ApiPropertyOptional({ example: '+1 (555) 000-0000', nullable: true })
    value: string | null;

    @ApiProperty({ example: 'Giám đốc' })
    position: string;

    @ApiProperty({ example: 'CITIZEN_ID' })
    idType: string;

    @ApiProperty({ example: '001234567890' })
    idNumber: string;

    @ApiProperty({ example: '2023-01-15' })
    idIssueDate: Date;

    @ApiProperty({ example: 'https://...', nullable: true })
    idFrontImgUrl: string | null;

    @ApiProperty({ example: 'https://...', nullable: true })
    idBackImgUrl: string | null;

    @ApiProperty({ example: true })
    isAuthorizedUser: boolean;

    @ApiProperty({ example: 'https://...', nullable: true })
    authLetterDocUrl: string | null;

    @ApiProperty({ example: '0901234567', nullable: true })
    phoneNumber: string | null;
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
    requiresUpdate: boolean;

    @ApiPropertyOptional({ example: 'Phone number mismatch with tax document.', nullable: true })
    adminFeedback?: string | null;

    @ApiPropertyOptional({ example: true, nullable: true, description: 'Whether this field was verified by admin (from partner_review_log)' })
    isVerified?: boolean | null;
}

// ============================================================================
// Document Verification DTOs
// ============================================================================

export enum DocumentStatusDto {
    PENDING = 'pending',
    APPROVED = 'approved',
    REJECTED = 'rejected',
    REVISION_REQUIRED = 'revision_required',
    MISSING = 'missing',
}

export class VerificationDocumentDto {
    @ApiProperty({ example: 'id_front', description: 'Document identifier' })
    id: string;

    @ApiProperty({ example: 'Front Side ID', description: 'Display label for the document' })
    label: string;

    @ApiPropertyOptional({ example: 'https://example.com/id_front_v1.jpg', nullable: true })
    fileUrl?: string | null;

    @ApiPropertyOptional({ example: 'id_front_v1.jpg', nullable: true })
    fileName?: string | null;

    @ApiProperty({ enum: DocumentStatusDto, example: DocumentStatusDto.PENDING })
    status: DocumentStatusDto;

    @ApiProperty({ example: false })
    requiresUpdate: boolean;

    @ApiPropertyOptional({ example: 'Front ID photo is too dark and blurry.', nullable: true })
    adminFeedback?: string | null;

    @ApiPropertyOptional({ example: true, nullable: true, description: 'Whether this document was verified by admin (from partner_review_log)' })
    isVerified?: boolean | null;
}

export class DocumentVerificationInfoDto {
    @ApiPropertyOptional({ type: VerificationDocumentDto, nullable: true })
    businessLicense?: VerificationDocumentDto | null;

    @ApiPropertyOptional({ type: VerificationDocumentDto, nullable: true })
    authorizationLetter?: VerificationDocumentDto | null;

    @ApiPropertyOptional({ type: VerificationDocumentDto, nullable: true })
    taxCertificate?: VerificationDocumentDto | null;
}

// ============================================================================
// Partner Info DTO
// ============================================================================

export class PartnerInfoDto {
    @ApiProperty({ type: VerificationStringFieldDto })
    taxCode: VerificationStringFieldDto;

    @ApiProperty({ type: VerificationStringFieldDto })
    legalName: VerificationStringFieldDto;

    @ApiProperty({ type: VerificationStringFieldDto })
    brandName: VerificationStringFieldDto;

    @ApiProperty({ type: VerificationStringFieldDto })
    businessType: VerificationStringFieldDto;

    @ApiProperty({ type: VerificationOptionalStringFieldDto })
    phoneNumber: VerificationOptionalStringFieldDto;
}

// ============================================================================
// Location Details DTO
// ============================================================================

export class LocationDetailsInfoDto {
    @ApiProperty({ type: VerificationStringFieldDto })
    provinceId: VerificationStringFieldDto;

    @ApiProperty({ type: VerificationStringFieldDto })
    districtId: VerificationStringFieldDto;

    @ApiProperty({ type: VerificationStringFieldDto })
    wardId: VerificationStringFieldDto;

    @ApiProperty({ type: VerificationStringFieldDto })
    streetAddress: VerificationStringFieldDto;
}

// ============================================================================
// Legal Representative DTO
// ============================================================================

export class LegalRepresentativeInfoDto {
    @ApiProperty({ type: VerificationStringFieldDto })
    fullName: VerificationStringFieldDto;

    @ApiProperty({ type: VerificationStringFieldDto })
    position: VerificationStringFieldDto;

    @ApiProperty({ type: VerificationOptionalStringFieldDto })
    phoneNumber: VerificationOptionalStringFieldDto;

    @ApiProperty({ type: VerificationStringFieldDto })
    idType: VerificationStringFieldDto;

    @ApiProperty({ type: VerificationStringFieldDto })
    idNumber: VerificationStringFieldDto;

    @ApiProperty({ type: VerificationStringFieldDto })
    idIssueDate: VerificationStringFieldDto;

    @ApiProperty({ type: VerificationDocumentDto })
    idFrontImage: VerificationDocumentDto;

    @ApiProperty({ type: VerificationDocumentDto })
    idBackImage: VerificationDocumentDto;

    @ApiProperty({ type: DocumentVerificationInfoDto })
    documents: DocumentVerificationInfoDto;
}

// ============================================================================
// Main Response DTO
// ============================================================================

export class MyProfileResponseDto {
    @ApiProperty({ example: 'uuid' })
    id: string;

    @ApiProperty({ type: PartnerInfoDto })
    partnerInfo: PartnerInfoDto;

    @ApiProperty({ type: LocationDetailsInfoDto })
    locationDetails: LocationDetailsInfoDto;

    @ApiProperty({ type: LegalRepresentativeInfoDto })
    legalRepresentative: LegalRepresentativeInfoDto;

    @ApiProperty({ enum: PartnerVerificationStatus, example: PartnerVerificationStatus.PENDING })
    verificationStatus: PartnerVerificationStatus;

    @ApiPropertyOptional({ example: null, nullable: true })
    verificationCompletedAt: Date | null;

    @ApiProperty({ example: '2024-01-15T10:30:00Z' })
    createdAt: Date;
}
