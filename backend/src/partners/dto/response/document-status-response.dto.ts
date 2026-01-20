import { ApiProperty } from '@nestjs/swagger';
import { DocumentType } from '@/partners/enum/document-type.enum';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';

export class DocumentStatusDto {
    @ApiProperty({ enum: DocumentType })
    documentType: DocumentType;

    @ApiProperty({ example: 'Giấy phép ĐKKD' })
    description: string;

    @ApiProperty({ example: true })
    isRequired: boolean;

    @ApiProperty({
        description: 'Computed status: MISSING if not uploaded, PENDING if not reviewed, VALID/INVALID based on isValid',
        enum: ['MISSING', 'PENDING', 'VALID', 'INVALID'],
        example: 'PENDING',
    })
    status: 'MISSING' | 'PENDING' | 'VALID' | 'INVALID';

    @ApiProperty({ example: false, description: 'Whether the document has been reviewed by admin' })
    isReviewed: boolean;

    @ApiProperty({ example: true, description: 'Whether the document is valid (only meaningful when isReviewed=true)' })
    isValid: boolean;

    @ApiProperty({
        example: 'https://r2.example.com/documents/license.pdf',
        nullable: true,
        description: 'URL of submitted document',
    })
    documentUrl: string | null;

    @ApiProperty({
        example: 'documents/abc-123/1234567890-license.pdf',
        nullable: true,
        description: 'R2/S3 key of submitted document',
    })
    documentKey: string | null;

    @ApiProperty({
        example: 'Ảnh bị mờ, vui lòng chụp lại',
        nullable: true,
        description: 'Admin feedback (only for invalid documents)',
    })
    adminFeedback: string | null;

    @ApiProperty({ example: '2024-01-15T10:30:00Z', nullable: true })
    uploadedAt: Date | null;

    @ApiProperty({ example: 'doc-uuid', nullable: true })
    documentId: string | null;
}

export class DocumentStatusResponseDto {
    @ApiProperty({
        type: [DocumentStatusDto],
        description: 'List of required documents with their status',
    })
    documents: DocumentStatusDto[];

    @ApiProperty({
        example: 5,
        description: 'Total number of required documents',
    })
    totalRequired: number;

    @ApiProperty({
        example: 3,
        description: 'Number of valid documents',
    })
    totalValid: number;

    @ApiProperty({
        enum: PartnerVerificationStatus,
        example: PartnerVerificationStatus.PENDING,
        description: 'Overall verification status',
    })
    verificationStatus: PartnerVerificationStatus;
}
