import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  IsArray,
  IsOptional,
  IsString,
  IsUrl,
  MaxLength,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { UpdatePartnerCertificationDto } from './update-partner-profile-completion.dto';

/**
 * Request DTO for updating the partner's public-facing clinic profile.
 *
 * Scoped to storefront fields only — admin-verified business data
 * (brandName, taxCode, address, legal rep, KYC docs) is NOT editable
 * through this endpoint.
 */
export class UpdatePartnerPublicProfileDto {
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
    description: 'Public clinic profile description (120–1000 chars recommended)',
    example: 'A modern wellness clinic focused on long-term care.',
  })
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  description?: string;

  @ApiPropertyOptional({
    description: 'Gallery image URLs shown on the clinic profile (max 8)',
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
    description: 'Trust badges and certifications shown on the clinic profile',
    type: [UpdatePartnerCertificationDto],
  })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => UpdatePartnerCertificationDto)
  certifications?: UpdatePartnerCertificationDto[];
}
