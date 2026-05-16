import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class SeedUserDto {
  @ApiPropertyOptional({
    type: String,
    description: 'Unique lookup key for this seeded user',
  })
  @IsOptional()
  @IsString()
  key?: string;

  @ApiProperty({ type: String, example: 'user@test.healytics.vn' })
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @ApiProperty({ type: String, example: 'Password123!' })
  @IsString()
  @IsNotEmpty()
  password: string;

  @ApiPropertyOptional({ type: String, example: 'Nguyen' })
  @IsOptional()
  @IsString()
  firstName?: string;

  @ApiPropertyOptional({ type: String, example: 'Van A' })
  @IsOptional()
  @IsString()
  lastName?: string;

  @ApiPropertyOptional({ type: String, example: '0901234567' })
  @IsOptional()
  @IsString()
  phone?: string;
}
