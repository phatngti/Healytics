import { ApiProperty } from '@nestjs/swagger';
import { DocumentType } from '../../enum/document-type.enum';
import { DocumentStatus } from '../../enum/document-status.enum';

export class SubmitDocumentResponseDto {
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
        description: 'Status of the document (always PENDING after submission)',
        enum: DocumentStatus,
        example: DocumentStatus.PENDING,
    })
    status: DocumentStatus;

    @ApiProperty({
        description: 'Timestamp when document was uploaded',
        example: '2024-01-19T06:45:00Z',
    })
    uploadedAt: Date;

    @ApiProperty({
        description: 'Document URL (HTTP link for registration documents, R2 URL for uploaded documents)',
        example: 'https://example.com/documents/identity-card.jpg',
        nullable: true,
    })
    documentUrl: string | null;

    @ApiProperty({
        description: 'R2/S3 key for uploaded documents (null for registration documents)',
        example: 'documents/abc-123/1234567890-business-license.pdf',
        nullable: true,
        required: false,
    })
    documentKey: string | null;
}
