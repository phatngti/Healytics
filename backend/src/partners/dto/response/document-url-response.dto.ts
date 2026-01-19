import { ApiProperty } from '@nestjs/swagger';
import { DocumentType } from '../../enum/document-type.enum';
import { DocumentStatus } from '../../enum/document-status.enum';

export class DocumentUrlResponseDto {
    @ApiProperty({
        description: 'Signed URL to view or download the document',
        example: 'https://r2.example.com/signed-url...',
        nullable: true,
    })
    url: string | null;

    @ApiProperty({
        description: 'Type of the document',
        enum: DocumentType,
        example: DocumentType.BUSINESS_LICENSE,
    })
    documentType: DocumentType;

    @ApiProperty({
        description: 'Current status of the document',
        enum: DocumentStatus,
        example: DocumentStatus.APPROVED,
    })
    status: DocumentStatus;
}
