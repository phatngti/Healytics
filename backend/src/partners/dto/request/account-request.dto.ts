import { ApiProperty } from '@nestjs/swagger';
import {
  IsEmail,
  IsString,
  IsNotEmpty,
  MinLength,
  MaxLength,
  Matches,
} from 'class-validator';

class AccountRequestDto {
  @ApiProperty({
    example: 'Password123',
    description: 'Password (min 8 characters)',
  })
  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  password: string;

  @ApiProperty({
    example: 'contact@spahanoi.com',
    description: 'Email address',
  })
  @IsEmail()
  email: string;
}

export { AccountRequestDto };
