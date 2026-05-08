import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

/**
 * Response DTO indicating whether the email is already registered.
 */
export class CheckEmailResponseDto {
  @ApiProperty({
    example: true,
    description: 'Whether the email is already registered',
    type: Boolean,
  })
  @Expose()
  exists: boolean;
}
