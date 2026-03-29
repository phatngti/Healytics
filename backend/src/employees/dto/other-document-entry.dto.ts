import { IsString, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

/**
 * Represents a single document within the `other_documents` collection.
 * Used as an array element inside a VerificationDocumentEntryDto
 * when fieldKey is 'other_documents'.
 */
export class DocumentEntryDto {
  @ApiProperty({
    example: 'Health Certificate',
    description: 'Display name of the document',
  })
  @IsString()
  name: string;

  @ApiProperty({
    example: 'https://storage.example.com/docs/health-cert.pdf',
    description: 'URL of the uploaded document',
  })
  @IsString()
  url: string;

  @ApiPropertyOptional({
    example: '2026-03-21T14:00:00.000Z',
    description: 'ISO timestamp of the last update',
  })
  @IsString()
  @IsOptional()
  updatedTime?: string;
}
