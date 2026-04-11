import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

/**
 * Trust metrics bar displayed on the clinic info screen.
 *
 * Field-mapping contract (Partner -> ClinicService -> DTO -> user_app):
 * | DTO field        | Source                                          | user_app entity field    |
 * |------------------|-------------------------------------------------|--------------------------|
 * | rating           | avg treatment-review rating across products      | ClinicTrustMetrics.rating          |
 * | reviewCount      | total treatment-review count across products     | ClinicTrustMetrics.reviewCount     |
 * | experienceLabel  | derived from Partner.createdAt (years active)    | ClinicTrustMetrics.experienceLabel |
 * | clientsLabel     | unique booking users across products             | ClinicTrustMetrics.clientsLabel    |
 */
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

/**
 * Clinic profile returned by `GET /user/clinics/:id/info`.
 *
 * Field-mapping contract (admin_panel sign-up -> Partner entity -> this DTO):
 * | DTO field      | Partner column / derivation            | Admin sign-up form key         |
 * |----------------|----------------------------------------|--------------------------------|
 * | id             | Partner.id (auto UUID)                 | —                              |
 * | name           | Partner.brandName                      | brand_name                     |
 * | coverImageUrl  | Partner.coverImageUrl (post-signup)     | —                              |
 * | logoImageUrl   | Partner.logoImageUrl (post-signup)      | —                              |
 * | gallery        | Partner.gallery (post-signup)           | —                              |
 * | followersLabel | formatCount(Partner.followerCount)      | — (derived)                   |
 * | reviewsLabel   | formatCount(totalReviewCount)           | — (derived)                   |
 * | description    | Partner.description (post-signup)       | —                              |
 * | trustMetrics   | see ClinicTrustMetricsDto              | — (derived)                   |
 * | certifications | PartnerCertification rows              | — (post-signup)               |
 * | specialists    | Employee rows (active, limit 5)        | — (post-signup)               |
 * | businessTypes  | Partner.businessType (BusinessType[])   | business_types (enum codes)   |
 * | address        | Partner.streetAddress                   | street_address                |
 * | phoneNumber    | Partner.phoneNumber                     | clinic_phone (dedicated field)|
 */
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
