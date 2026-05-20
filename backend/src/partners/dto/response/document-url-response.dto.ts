import { ApiProperty } from '@nestjs/swagger';
import { DocumentType } from '../../enum/document-type.enum';

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
    description: 'Whether the document has been reviewed by admin',
    example: true,
  })
  isReviewed: boolean;

  @ApiProperty({
    description:
      'Whether the document is valid (only meaningful when isReviewed=true)',
    example: true,
  })
  isValid: boolean;
}
