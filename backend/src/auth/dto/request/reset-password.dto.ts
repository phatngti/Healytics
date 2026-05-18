import { ApiProperty } from '@nestjs/swagger';
import { IsString, MinLength } from 'class-validator';

export class ResetPasswordDto {
  @ApiProperty({
    description: 'Password reset token received from the reset email link',
  })
  @IsString()
  token: string;

  @ApiProperty({
    description: 'New password for the account',
    minLength: 8,
  })
  @IsString()
  @MinLength(8)
  password: string;
}
