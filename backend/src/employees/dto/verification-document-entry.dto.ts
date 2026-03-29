import { IsString, IsArray, IsOptional, ValidateNested } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { DocumentEntryDto } from './other-document-entry.dto';

/**
 * Represents a single verification document entry for an employee.
 * Used as an array element in the `verificationDocuments` JSONB column.
 *
 * Shape: { fieldKey, documents: [{ name, url, updatedTime }] }
 *
 * Examples:
 * - Regular document:  { fieldKey: 'id_card', documents: [{ name: 'ID Card', url: '...', updatedTime: '...' }] }
 * - Other documents:   { fieldKey: 'other_documents', documents: [{ name: 'Health Cert', url: '...', updatedTime: '...' }, ...] }
 */
export class VerificationDocumentEntryDto {
  @ApiProperty({
    example: 'id_card',
    description: 'Unique key identifying the document field (e.g. "id_card", "other_documents")',
  })
  @IsString()
  fieldKey: string;

  @ApiPropertyOptional({
    type: [DocumentEntryDto],
    description: 'Array of document entries for this field',
    example: [
      { name: 'ID Card', url: 'https://storage.example.com/id-card.jpg', updatedTime: '2026-03-21T14:00:00.000Z' },
    ],
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => DocumentEntryDto)
  @IsOptional()
  documents?: DocumentEntryDto[];
}
