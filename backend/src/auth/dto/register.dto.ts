import { IsEmail, IsNotEmpty, MinLength, IsOptional, ValidateNested } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { RegisterProfileDto } from './register-profile.dto';

export class RegisterDto {
  @ApiProperty({ example: 'newuser@example.com', description: 'Email address for registration' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 's3cureP@ssw0rd', description: 'Password (min 8 characters)' })
  @IsNotEmpty()
  @MinLength(8)
  password: string;

  @ApiPropertyOptional({ type: RegisterProfileDto, description: 'Optional profile data to create alongside the account' })
  @IsOptional()
  @ValidateNested()
  @Type(() => RegisterProfileDto)
  profile?: RegisterProfileDto;
}
