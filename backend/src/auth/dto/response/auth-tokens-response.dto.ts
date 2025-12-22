import { ApiProperty } from '@nestjs/swagger';

export class AuthTokensDto {
  @ApiProperty({ example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' })
  access_token: string;

  @ApiProperty({ example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...refresh' })
  refresh_token: string;

  @ApiProperty({
    example: '3600s',
    description: 'Access token TTL as configured',
  })
  access_expires_in?: string;

  @ApiProperty({
    example: '7d',
    description: 'Refresh token TTL as configured',
  })
  refresh_expires_in?: string;
}
