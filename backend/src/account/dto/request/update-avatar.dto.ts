import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty } from 'class-validator';

/**
 * DTO for updating the user's avatar URL.
 * Expects the S3 storage key returned after
 * a successful upload.
 */
export class UpdateAvatarDto {
  @ApiProperty({
    description: 'S3 storage key of the uploaded avatar',
    example: 'avatars/abc123.png',
  })
  @IsString()
  @IsNotEmpty()
  avatarUrl: string;
}
