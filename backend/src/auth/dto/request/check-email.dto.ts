import { ApiProperty } from '@nestjs/swagger';
import { IsEmail } from 'class-validator';

/**
 * DTO for checking whether an email is already registered.
 */
export class CheckEmailDto {
  @ApiProperty({
    example: 'user@example.com',
    description: 'The email address to check for existence',
    format: 'email',
    type: String,
    required: true,
  })
  @IsEmail()
  email: string;
}
