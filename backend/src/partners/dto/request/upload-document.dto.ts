import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsNotEmpty } from 'class-validator';
import { DocumentType } from '@/partners/enum/document-type.enum';

export class UploadDocumentDto {
    @ApiProperty({
        enum: DocumentType,
        example: DocumentType.BUSINESS_LICENSE,
        description: 'Type of document being uploaded',
        required: true,
    })
    @IsEnum(DocumentType)
    @IsNotEmpty()
    documentType: DocumentType;
}
