import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class ClinicTrustMetricsDto {
  @ApiProperty({ example: 4.9 })
  rating: number;

  @ApiProperty({ example: 2500 })
  reviewCount: number;

  @ApiProperty({ example: '5+ Yrs' })
  experienceLabel: string;

  @ApiProperty({ example: '15k' })
  clientsLabel: string;
}

export class ClinicCertificationDto {
  @ApiProperty({ example: 'ISO 9001:2015' })
  title: string;

  @ApiPropertyOptional({ example: 'Quality Management' })
  subtitle: string | null;

  @ApiProperty({ example: 'workspace_premium' })
  iconName: string;
}

export class ClinicSpecialistPreviewDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ example: 'Dr. Sarah' })
  name: string;

  @ApiProperty({ example: 'Senior Therapist' })
  role: string;

  @ApiPropertyOptional()
  imageUrl: string | null;

  @ApiPropertyOptional({ example: '5 Yrs Exp' })
  experienceLabel: string | null;
}

export class ClinicInfoResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ example: 'Healytics Wellness Center' })
  name: string;

  @ApiPropertyOptional()
  coverImageUrl: string | null;

  @ApiPropertyOptional()
  logoImageUrl: string | null;

  @ApiProperty({ type: [String] })
  gallery: string[];

  @ApiProperty({ example: '15k' })
  followersLabel: string;

  @ApiProperty({ example: '2.5k' })
  reviewsLabel: string;

  @ApiPropertyOptional()
  description: string | null;

  @ApiProperty({ type: ClinicTrustMetricsDto })
  trustMetrics: ClinicTrustMetricsDto;

  @ApiProperty({ type: [ClinicCertificationDto] })
  certifications: ClinicCertificationDto[];

  @ApiProperty({ type: [ClinicSpecialistPreviewDto] })
  specialists: ClinicSpecialistPreviewDto[];

  @ApiProperty({ type: [String] })
  businessTypes: string[];

  @ApiPropertyOptional()
  address: string | null;

  @ApiPropertyOptional()
  phoneNumber: string | null;
}
