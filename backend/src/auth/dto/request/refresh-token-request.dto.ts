import { IsNotEmpty, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

/**
 * Request DTO for refreshing authentication tokens.
 */
export class RefreshTokenRequestDto {
  @ApiProperty({
    description: 'Refresh token obtained from login or previous refresh',
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...refresh',
  })
  @IsString()
  @IsNotEmpty()
  refresh_token: string;
}
