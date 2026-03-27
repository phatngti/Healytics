import { ApiProperty } from '@nestjs/swagger';

export class RegisterPartnerResponseDto {
    @ApiProperty({
        example: '123e4567-e89b-12d3-a456-426614174000',
        description: 'ID of the created partner account',
    })
    accountId: string;

    @ApiProperty({
        example: '987e6543-e21b-98d7-b654-321987654321',
        description: 'ID of the created business entity',
    })
    businessEntityId: string;

    @ApiProperty({ example: 'success', description: 'Registration status' })
    status: string;

    @ApiProperty({
        example: 'Partner registration successful',
        description: 'Message',
    })
    message: string;

    @ApiProperty({
        example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
        description: 'JWT access token for immediate authentication',
    })
    access_token: string;

    @ApiProperty({
        example: '3600s',
        description: 'Access token expiration time',
    })
    access_expires_in?: string;

    @ApiProperty({
        example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
        description: 'JWT refresh token for obtaining new access tokens',
    })
    refresh_token: string;

    @ApiProperty({
        example: '7d',
        description: 'Refresh token expiration time',
    })
    refresh_expires_in?: string;
}
