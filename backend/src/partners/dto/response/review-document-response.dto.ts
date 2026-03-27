import { ApiProperty } from '@nestjs/swagger';
import { DocumentType } from '../../enum/document-type.enum';

export class ReviewDocumentResponseDto {
    @ApiProperty({
        description: 'Document ID',
        example: '123e4567-e89b-12d3-a456-426614174000',
    })
    id: string;

    @ApiProperty({
        description: 'Type of the document',
        enum: DocumentType,
        example: DocumentType.BUSINESS_LICENSE,
    })
    documentType: DocumentType;

    @ApiProperty({
        description: 'Whether the document has been reviewed',
        example: true,
    })
    isReviewed: boolean;

    @ApiProperty({
        description: 'Whether the document is valid after review',
        example: true,
    })
    isValid: boolean;

    @ApiProperty({
        description: 'Admin feedback (especially when invalid)',
        example: 'Document is unclear, please re-upload a clearer version',
        nullable: true,
    })
    adminFeedback: string | null;

    @ApiProperty({
        description: 'Internal verification notes',
        example: 'Verified against tax database',
        nullable: true,
    })
    verificationNotes: string | null;

    @ApiProperty({
        description: 'Admin account ID who verified',
        example: '123e4567-e89b-12d3-a456-426614174001',
        nullable: true,
    })
    verifiedBy: string | null;
}
