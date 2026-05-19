import { ApiProperty } from '@nestjs/swagger';

export class ValidatePasswordResetCodeResponseDto {
  @ApiProperty({
    description: 'Human-readable status message',
    example: 'Password reset code verified.',
  })
  message: string;

  @ApiProperty({
    description:
      'Short-lived token required by the final reset-password endpoint',
  })
  resetToken: string;
}
