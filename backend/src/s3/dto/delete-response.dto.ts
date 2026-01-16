import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

/**
 * Response DTO for file deletion.
 */
export class DeleteFileResponseDto {
  @Expose()
  @ApiProperty({
    description: 'Confirmation message',
    example: 'File deleted successfully',
  })
  message: string;
}
