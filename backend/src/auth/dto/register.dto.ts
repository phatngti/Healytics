import { IsEmail, IsNotEmpty, MinLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class RegisterDto {
  @ApiProperty({ example: 'newuser@example.com', description: 'Email address for registration' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 's3cureP@ssw0rd', description: 'Password (min 8 characters)' })
  @IsNotEmpty()
  @MinLength(8)
  password: string;
}
