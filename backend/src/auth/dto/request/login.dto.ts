import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty } from 'class-validator';

export class LoginDto {
  @ApiProperty({
    example: 'newuser@example.com',
    description: 'The email of the user',
    format: 'email',
    type: String,
    required: true,
  })
  @IsEmail()
  email: string;

  @ApiProperty({
    example: 's3cureP@ssw0rd',
    description: 'The password of the user',
    format: 'password',
    type: String,
    required: true,
  })
  @IsNotEmpty()
  password: string;
}
