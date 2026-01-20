import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsNotEmpty, IsOptional, IsString, IsUrl } from 'class-validator';
import { DocumentType } from '@/partners/enum/document-type.enum';

export class SubmitDocumentDto {
    @ApiProperty({
        enum: DocumentType,
        example: DocumentType.BUSINESS_LICENSE,
        description: 'Type of document being submitted',
    })
    @IsEnum(DocumentType)
    @IsNotEmpty()
    documentType: DocumentType;

    @ApiProperty({
        example: 'https://r2.example.com/documents/1234-license.pdf',
        description: 'R2 URL of the uploaded document',
    })
    @IsUrl()
    documentUrl?: string;

    @ApiProperty({
        description: 'Storage key for the document (if uploaded to R2)',
        required: false,
        example: 'documents/123/file.pdf'
    })
    @IsOptional()
    @IsString()
    documentKey?: string;
}
