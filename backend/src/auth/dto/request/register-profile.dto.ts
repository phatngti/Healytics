import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsDateString,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUUID,
  Matches,
  ValidateNested,
} from 'class-validator';

export class RegisterAddressDto {
  @ApiProperty({ example: '123 Nguyen Hue Street' })
  @IsString()
  @IsNotEmpty()
  streetAddress: string;

  @ApiProperty({
    example: '0f0d876f-92f1-4fcb-8a40-1fd3dd115d6b',
    description: 'Province/city Location UUID',
  })
  @IsUUID()
  @IsNotEmpty()
  provinceId: string;

  @ApiProperty({
    example: '7c4020d4-343d-4a63-b017-6df5f82d8814',
    description: 'District Location UUID',
  })
  @IsUUID()
  @IsNotEmpty()
  districtId: string;

  @ApiProperty({
    example: 'aa3a7de4-4d1d-4bb5-a3c1-79ac1350c743',
    description: 'Ward/commune Location UUID',
  })
  @IsUUID()
  @IsNotEmpty()
  wardId: string;
}

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

  @ApiPropertyOptional({
    type: RegisterAddressDto,
    description: 'Address provided during user registration',
  })
  @IsOptional()
  @ValidateNested()
  @Type(() => RegisterAddressDto)
  address?: RegisterAddressDto;
}
