import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

/**
 * Response DTO for file URL retrieval.
 */
export class FileUrlResponseDto {
  @Expose()
  @ApiProperty({
    description: 'Public or signed URL for the file',
    example: 'https://cdn.example.com/1705401234567-profile-picture.png',
  })
  url: string;
}
