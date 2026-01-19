import { ApiProperty } from '@nestjs/swagger';
import { DocumentType } from '../../enum/document-type.enum';
import { DocumentStatus } from '../../enum/document-status.enum';

export class GetDocumentUrlResponseDto {
    @ApiProperty({
        description: 'Signed URL to view or download the document',
        example: 'https://r2.example.com/signed-url...',
    })
    url: string;

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
