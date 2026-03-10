import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class AuthTokensDto {
  @ApiProperty({ example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' })
  @Expose()
  access_token: string;

  @ApiProperty({ example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...refresh' })
  @Expose()
  refresh_token: string;

  @ApiProperty({
    example: '3600s',
    description: 'Access token TTL as configured',
  })
  @Expose()
  access_expires_in?: string;

  @ApiProperty({
    example: '7d',
    description: 'Refresh token TTL as configured',
  })
  @Expose()
  refresh_expires_in?: string;
}
