import { ApiProperty } from '@nestjs/swagger';
import { IsEmail } from 'class-validator';

export class ForgotPasswordDto {
  @ApiProperty({
    description: 'Email address for the account requesting password reset',
    format: 'email',
    example: 'user@healytics.vn',
  })
  @IsEmail()
  email: string;
}
