import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  IsArray,
  IsInt,
  IsOptional,
  IsString,
  IsUrl,
  Max,
  MaxLength,
  Min,
  MinLength,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';

export class UpdatePartnerCertificationDto {
  @ApiPropertyOptional({
    description: 'Existing certification id. Omit to create a new one.',
    example: '8d2ee5c7-4f58-46a5-8f8d-4a14a8fd9e2b',
  })
  @IsOptional()
  @IsString()
  id?: string;

  @ApiPropertyOptional({
    description: 'Certification title displayed on the public clinic profile',
    example: 'ISO 9001:2015',
  })
  @IsOptional()
  @IsString()
  @MinLength(1)
  @MaxLength(200)
  title?: string;

  @ApiPropertyOptional({
    description: 'Optional certification subtitle',
    example: 'Quality Management',
  })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  subtitle?: string | null;

  @ApiPropertyOptional({
    description: 'Material icon slug used by the public clinic UI',
    example: 'workspace_premium',
  })
  @IsOptional()
  @IsString()
  @MaxLength(50)
  iconName?: string;

  @ApiPropertyOptional({
    description: 'Sort order for certifications on the clinic profile',
    example: 1,
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(999)
  sortOrder?: number;
}

export class UpdatePartnerProfileCompletionDto {
  @ApiPropertyOptional({
    description: 'Public clinic cover image URL',
    example: 'https://cdn.example.com/clinic-cover.jpg',
  })
  @IsOptional()
  @IsUrl()
  coverImageUrl?: string;

  @ApiPropertyOptional({
    description: 'Public clinic logo image URL',
    example: 'https://cdn.example.com/clinic-logo.jpg',
  })
  @IsOptional()
  @IsUrl()
  logoImageUrl?: string;

  @ApiPropertyOptional({
    description: 'Public clinic profile description',
    example: 'A modern wellness clinic focused on long-term care.',
  })
  @IsOptional()
  @IsString()
  @MaxLength(1000_000_000)
  description?: string;

  @ApiPropertyOptional({
    description: 'Gallery image URLs shown on the clinic profile',
    type: [String],
    example: [
      'https://cdn.example.com/gallery-1.jpg',
      'https://cdn.example.com/gallery-2.jpg',
    ],
  })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(8)
  @IsUrl({}, { each: true })
  gallery?: string[];

  @ApiPropertyOptional({
    description: 'Optional trust badges/certifications shown on the clinic',
    type: [UpdatePartnerCertificationDto],
  })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => UpdatePartnerCertificationDto)
  certifications?: UpdatePartnerCertificationDto[];
}
