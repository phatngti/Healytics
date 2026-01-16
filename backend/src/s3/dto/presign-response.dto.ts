import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

/**
 * Response DTO for presigned upload URL.
 */
export class PresignResponseDto {
  @Expose()
  @ApiProperty({
    description: 'Presigned URL for uploading the file',
    example: 'https://bucket.r2.cloudflarestorage.com/...',
  })
  uploadUrl: string;

  @Expose()
  @ApiProperty({
    description: 'Storage key for the uploaded file',
    example: '1705401234567-profile-picture.png',
  })
  key: string;
}
