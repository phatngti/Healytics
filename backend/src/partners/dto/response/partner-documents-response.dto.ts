import { ApiProperty } from '@nestjs/swagger';
import { DocumentType } from '../../enum/document-type.enum';

export class PartnerDocumentDto {
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
    description: 'Whether the document has been reviewed by admin',
    example: false,
  })
  isReviewed: boolean;

  @ApiProperty({
    description: 'Whether the document is valid',
    example: true,
  })
  isValid: boolean;

  @ApiProperty({
    description: 'Timestamp when document was uploaded',
    example: '2024-01-19T06:45:00Z',
  })
  uploadedAt: Date;

  @ApiProperty({
    description: 'Admin feedback (especially when invalid)',
    example: 'Document is unclear, please re-upload a clearer version',
    nullable: true,
  })
  adminFeedback: string | null;

  @ApiProperty({
    description:
      'Document URL (HTTP link for registration documents, R2 URL for uploaded documents)',
    example: 'https://example.com/documents/identity-card.jpg',
    nullable: true,
  })
  documentUrl: string | null;

  @ApiProperty({
    description: 'Document key in R2/S3 (null for registration documents)',
    example: 'documents/abc-123/1234567890-business-license.pdf',
    nullable: true,
    required: false,
  })
  documentKey: string | null;
}

export class PartnerDocumentsResponseDto {
  @ApiProperty({
    description: 'List of all documents for the partner',
    type: [PartnerDocumentDto],
  })
  documents: PartnerDocumentDto[];
}
