import { IsNotEmpty, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

/**
 * Request DTO for generating presigned upload URL.
 */
export class PresignRequestDto {
  @ApiProperty({
    description: 'Original file name',
    example: 'profile-picture.png',
  })
  @IsString()
  @IsNotEmpty()
  fileName: string;

  @ApiProperty({
    description: 'MIME type of the file',
    example: 'image/png',
  })
  @IsString()
  @IsNotEmpty()
  contentType: string;
}
