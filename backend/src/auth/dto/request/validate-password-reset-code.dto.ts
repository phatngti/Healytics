import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsString, Matches } from 'class-validator';

export class ValidatePasswordResetCodeDto {
  @ApiProperty({
    description: 'Email address that requested the password reset code',
    format: 'email',
    example: 'user@healytics.vn',
  })
  @IsEmail()
  email: string;

  @ApiProperty({
    description: 'One-time password reset code sent to email',
    example: '123456',
  })
  @IsString()
  @Matches(/^\d{6}$/)
  code: string;
}
