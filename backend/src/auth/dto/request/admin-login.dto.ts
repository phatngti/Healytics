import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty } from 'class-validator';

export class AdminLoginDto {
  @ApiProperty({
    example: 'admin@healytics.com',
    description: 'The email of the admin/partner user',
    format: 'email',
    type: String,
    required: true,
  })
  @IsEmail()
  email: string;

  @ApiProperty({
    example: 's3cureP@ssw0rd',
    description: 'The password of the admin/partner user',
    format: 'password',
    type: String,
    required: true,
  })
  @IsNotEmpty()
  password: string;
}
