import { ApiProperty } from '@nestjs/swagger';
import { DocumentType } from '@/partners/enum/document-type.enum';
import { DocumentStatus } from '@/partners/enum/document-status.enum';

export class DocumentStatusDto {
    @ApiProperty({ enum: DocumentType })
    documentType: DocumentType;

    @ApiProperty({ example: 'Giấy phép ĐKKD' })
    description: string;

    @ApiProperty({ example: true })
    isRequired: boolean;

    @ApiProperty({
        description: 'Status of the document. Returns "MISSING" if not uploaded yet.',
        enum: [...Object.values(DocumentStatus), 'MISSING'],
        example: 'MISSING',
    })
    status: DocumentStatus | 'MISSING';

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
        description: 'Admin feedback (only for rejected documents)',
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
        description: 'Number of approved documents',
    })
    totalApproved: number;

    @ApiProperty({
        example: false,
        description: 'Whether business is fully verified',
    })
    isVerified: boolean;
}
