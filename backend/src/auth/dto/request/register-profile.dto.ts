import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsDateString, Matches } from 'class-validator';

export class RegisterProfileDto {
  @ApiPropertyOptional({ example: 'Jane' })
  @IsOptional()
  @IsString()
  firstName?: string;

  @ApiPropertyOptional({ example: 'Doe' })
  @IsOptional()
  @IsString()
  lastName?: string;

  @ApiPropertyOptional({ example: '+1234567890' })
  @IsOptional()
  @Matches(/^(?:\+84|84|0)(?:3|5|7|8|9)[0-9]{8}$/, {
    message:
      'Phone number must be a valid Vietnamese phone number (e.g., +84901234567, 84901234567, or 0901234567)',
  })
  @IsString()
  phone?: string;

  @ApiPropertyOptional({
    example: 'Patient is healthy',
    description: 'Short bio or notes',
    type: String,
  })
  @IsOptional()
  @IsString()
  bio?: string;

  @ApiPropertyOptional({
    example: '1990-01-01',
    description: 'Date of birth in ISO format',
  })
  @IsOptional()
  @IsDateString()
  dateOfBirth?: string;
}
