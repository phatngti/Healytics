import { ApiProperty } from '@nestjs/swagger';

export class PasswordResetResponseDto {
  @ApiProperty({
    description: 'Human-readable status message',
    example: 'If the email is registered, a password reset link has been sent.',
  })
  message: string;
}
